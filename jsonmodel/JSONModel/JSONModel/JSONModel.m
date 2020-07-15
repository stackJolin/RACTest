//
//  JSONModel.m
//  JSONModel
//

#if !__has_feature(objc_arc)
#error The JSONMOdel framework is ARC only, you can enable ARC on per file basis.
#endif


#import <objc/runtime.h>
#import <objc/message.h>


#import "JSONModel.h"
#import "JSONModelClassProperty.h"

#pragma mark - associated objects names
static const char * kMapperObjectKey;
static const char * kClassPropertiesKey;
static const char * kClassRequiredPropertyNamesKey;
static const char * kIndexPropertyNameKey;

#pragma mark - class static variables
static NSArray* allowedJSONTypes = nil;
static NSArray* allowedPrimitiveTypes = nil;
static JSONValueTransformer* valueTransformer = nil;
static Class JSONModelClass = NULL;

#pragma mark - model cache
// 全局KeyMapper
static JSONKeyMapper* globalKeyMapper = nil;

#pragma mark - JSONModel implementation
@implementation JSONModel
{
    NSString* _description;
}

#pragma mark - initialization methods

+(void)load
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // initialize all class static objects,
        // which are common for ALL JSONModel subclasses

        @autoreleasepool {
            
            allowedJSONTypes = @[
                [NSString class],
                [NSNumber class],
                [NSDecimalNumber class],
                [NSArray class],
                [NSDictionary class],
                [NSNull class], // immutable JSON classes
                [NSMutableString class],
                [NSMutableArray class],
                [NSMutableDictionary class] // mutable JSON classes
            ];

            // JSONModel所支持的基本的数据类型
            allowedPrimitiveTypes = @[
                @"BOOL",
                @"float",
                @"int",
                @"long",
                @"double",
                @"short",
                @"NSInteger",
                @"NSUInteger", //and some famous aliases
                @"Block"
            ];

            valueTransformer = [[JSONValueTransformer alloc] init];

            // This is quite strange, but I found the test isSubclassOfClass: (line ~291) to fail if using [JSONModel class].
            // somewhat related: https://stackoverflow.com/questions/6524165/nsclassfromstring-vs-classnamednsstring
            // //; seems to break the unit tests

            // Using NSClassFromString instead of [JSONModel class], as this was breaking unit tests, see below
            //http://stackoverflow.com/questions/21394919/xcode-5-unit-test-seeing-wrong-class
            JSONModelClass = NSClassFromString(NSStringFromClass(self));
        }
    });
}

- (id)init {
    self = [super init];
    if (self) {
        //do initial class setup
        [self __setup__];
    }
    return self;
}

- (void)__setup__ {
    //if first instance of this model, generate the property list
    if (!objc_getAssociatedObject(self.class, &kClassPropertiesKey)) {
        [self __inspectProperties];
    }
    
    //if there's a custom key mapper, store it in the associated object
    // 如果子类需要自定义keyMapper的话，自己重写 +(void)keyMapper 方法
    id mapper = [[self class] keyMapper];
    
    if (mapper && !objc_getAssociatedObject(self.class, &kMapperObjectKey) ) {
        objc_setAssociatedObject(self.class,
                                 &kMapperObjectKey,
                                 mapper,
                                 OBJC_ASSOCIATION_RETAIN // This is atomic，原子性
                                 );
    }
}

- (instancetype)initWithData:(NSData *)data error:(NSError *__autoreleasing *)err {
    //check for nil input
    if (!data) {
        if (err) *err = [JSONModelError errorInputIsNil];
        return nil;
    }
    //read the json
    JSONModelError* initError = nil;
    // data:需要解析的二进制数据
    // options:
    //         1.NSJSONReadingMutableContainers : 返回的数组和字典都是可变类型的
    //         2.NSJSONReadingMutableLeaves : iOS7之前可用
    //         3.NSJSONReadingAllowFragments : 最外层既不是字典也不是数组，例：NSString *num=@"\"abcd\""; https://stackoverflow.com/questions/16961025/nsjsonserialization-nsjsonreadingallowfragments-reading
    //         4.kNilOptions,这个类型是Mac上的，已经非常古老了。建议nil。https://stackoverflow.com/questions/24758086/nil-vs-kniloptions
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:kNilOptions
                                               error:&initError];

    if (initError) {
        if (err) *err = [JSONModelError errorBadJSON];
        return nil;
    }

    //init with dictionary
    id objModel = [self initWithDictionary:obj error:&initError];
    if (initError && err) *err = initError;
    return objModel;
}

- (id)initWithString:(NSString*)string error:(JSONModelError**)err {
    JSONModelError* initError = nil;
    id objModel = [self initWithString:string usingEncoding:NSUTF8StringEncoding error:&initError];
    if (initError && err) *err = initError;
    return objModel;
}

- (id)initWithString:(NSString *)string usingEncoding:(NSStringEncoding)encoding error:(JSONModelError**)err {
    //check for nil input
    if (!string) {
        if (err) *err = [JSONModelError errorInputIsNil];
        return nil;
    }
    
    JSONModelError* initError = nil;
    id objModel = [self initWithData:[string dataUsingEncoding:encoding] error:&initError];
    if (initError && err) *err = initError;
    return objModel;
}

- (id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err {
    //check for nil input
    if (!dict) {
        if (err) *err = [JSONModelError errorInputIsNil];
        return nil;
    }

    //invalid input, just create empty instance
    if (![dict isKindOfClass:[NSDictionary class]]) {
        if (err) *err = [JSONModelError errorInvalidDataWithMessage:@"Attempt to initialize JSONModel object using initWithDictionary:error: but the dictionary parameter was not an 'NSDictionary'."];
        return nil;
    }

    //create a class instance
    self = [self init];
    if (!self) {

        //super init didn't succeed
        if (err) *err = [JSONModelError errorModelIsInvalid];
        return nil;
    }
    
    // 检查输入的数据结构
    if (![self __doesDictionary:dict matchModelWithKeyMapper:self.__keyMapper error:err]) {
        return nil;
    }
    
    // import the data from a dictionary
    // 导入字典转换
    if (![self __importDictionary:dict withKeyMapper:self.__keyMapper validation:YES error:err]) {
        return nil;
    }
    
    //run any custom model validation
    if (![self validate:err]) {
        return nil;
    }

    //model is valid! yay!
    return self;
}

- (JSONKeyMapper*)__keyMapper {
    //get the model key mapper
    return objc_getAssociatedObject(self.class, &kMapperObjectKey);
}

/// 检查数据结构
- (BOOL)__doesDictionary:(NSDictionary*)dict
 matchModelWithKeyMapper:(JSONKeyMapper*)keyMapper
                   error:(NSError**)err
{
    // Json中的key
    NSArray* incomingKeysArray = [dict allKeys];
    
    // Model的属性Key
    NSMutableSet* requiredProperties = [self __requiredPropertyNames].mutableCopy;
    NSSet* incomingKeys = [NSSet setWithArray: incomingKeysArray];

    // transform the key names, if necessary
    // 1.转换key names，默认keyMapper 和 globalKeyMapper都是nil
    if (keyMapper || globalKeyMapper) {
        
        NSMutableSet* transformedIncomingKeys = [NSMutableSet setWithCapacity: requiredProperties.count];
        NSString* transformedName = nil;
        
        //loop over the required properties list
        for (JSONModelClassProperty* property in [self __properties__]) {
            
            transformedName = (keyMapper || globalKeyMapper) ? [self __mapString:property.name withKeyMapper:keyMapper] : property.name;
            
            //check if exists and if so, add to incoming keys
            id value;
            @try {
                value = [dict valueForKeyPath:transformedName];
            }
            @catch (NSException *exception) {
                value = dict[transformedName];
            }
            
            if (value) {
                [transformedIncomingKeys addObject: property.name];
            }
        }

        //overwrite the raw incoming list with the mapped key names
        incomingKeys = transformedIncomingKeys;
    }
    
    // 如果当前类的属性不是JSON数据所有Key的子集的话，模型化失败。isSubsetOfSet：空集是空集的子集
    if (![requiredProperties isSubsetOfSet:incomingKeys]) {
       
        //get a list of the missing properties
        [requiredProperties minusSet:incomingKeys];

        //not all required properties are in - invalid input
        JMLog(@"Incoming data was invalid [%@ initWithDictionary:]. Keys missing: %@", self.class, requiredProperties);

        if (err) *err = [JSONModelError errorInvalidDataWithMissingKeys:requiredProperties];
        return NO;
    }

    //not needed anymore
    incomingKeys= nil;
    requiredProperties= nil;

    return YES;
}

// 根据属性名A，获取对应Json字符串中的key
- (NSString*)__mapString:(NSString*)string withKeyMapper:(JSONKeyMapper *)keyMapper {
    if (keyMapper) {
        // custom mapper
        // 自定义的mapper去转换类
        NSString* mappedName = [keyMapper convertValue:string];
        // 如果自定义的mapper并没有转换name，那么检查globalKeyMapper并利用globalKeyMapper做转换
        if (globalKeyMapper && [mappedName isEqualToString: string]) {
            mappedName = [globalKeyMapper convertValue:string];
        }
        string = mappedName;
    }
    else if (globalKeyMapper) {
        //global keymapper
        string = [globalKeyMapper convertValue:string];
    }

    return string;
}

- (BOOL)__importDictionary:(NSDictionary*)dict
             withKeyMapper:(JSONKeyMapper*)keyMapper
                validation:(BOOL)validation
                     error:(NSError**)err
{
    //loop over the incoming keys and set self's properties
    for (JSONModelClassProperty* property in [self __properties__]) {

        //convert key name to model keys, if a mapper is provided
        NSString* jsonKeyPath = (keyMapper || globalKeyMapper) ? [self __mapString:property.name withKeyMapper:keyMapper] : property.name;
        //JMLog(@"keyPath: %@", jsonKeyPath);

        //general check for data type compliance
        id jsonValue;
        @try {
            // KVC 单级/多级取值
            jsonValue = [dict valueForKeyPath: jsonKeyPath];
        }
        @catch (NSException *exception) {
            jsonValue = dict[jsonKeyPath];
        }
        
        //check for Optional properties
        if (isNull(jsonValue)) {
            //skip this property, continue with next property
            if (property.isOptional || !validation) continue;
            
            if (err) {
                //null value for required property
                NSString* msg = [NSString stringWithFormat:@"Value of required model key %@ is null", property.name];
                JSONModelError* dataErr = [JSONModelError errorInvalidDataWithMessage:msg];
                *err = [dataErr errorByPrependingKeyPathComponent:property.name];
            }
            return NO;
        }
        
        Class jsonValueClass = [jsonValue class];
        BOOL isValueOfAllowedType = NO;

        for (Class allowedType in allowedJSONTypes) {
            if ( [jsonValueClass isSubclassOfClass: allowedType] ) {
                isValueOfAllowedType = YES;
                break;
            }
        }

        if (isValueOfAllowedType == NO) {
            //type not allowed
            JMLog(@"Type %@ is not allowed in JSON.", NSStringFromClass(jsonValueClass));

            if (err) {
                NSString* msg = [NSString stringWithFormat:@"Type %@ is not allowed in JSON.", NSStringFromClass(jsonValueClass)];
                JSONModelError* dataErr = [JSONModelError errorInvalidDataWithMessage:msg];
                *err = [dataErr errorByPrependingKeyPathComponent:property.name];
            }
            return NO;
        }

        //check if there's matching property in the model
        if (property) {
            // 如果自定义了setter方法，那么调用setter方法进行赋值
            if ([self __customSetValue:jsonValue forProperty:property]) {
                //skip to next JSON key
                continue;
            };
            
            // 设置基本类型
            if (property.type == nil && property.structName == nil) {
                
                //generic setter
                if (jsonValue != [self valueForKey:property.name]) {
                    [self setValue:jsonValue forKey: property.name];
                }
                
                //skip directly to the next key
                continue;
            }

            // 0.5) handle nils
            if (isNull(jsonValue)) {
                if ([self valueForKey:property.name] != nil) {
                    [self setValue:nil forKey: property.name];
                }
                continue;
            }
            
            // 1) 如果这个属性的类型是JSONModel的子类，递归解析
            if ([self __isJSONModelSubClass:property.type]) { // 顺序查找子属性是否是JSONModel，如果是的话，转换

                //initialize the property's model, store it
                JSONModelError* initErr = nil;
                id value = [[property.type alloc] initWithDictionary: jsonValue error:&initErr];
                
                if (!value) {
                    //skip this property, continue with next property
                    if (property.isOptional || !validation) continue;

                    // Propagate the error, including the property name as the key-path component
                    if((err != nil) && (initErr != nil))
                    {
                        *err = [initErr errorByPrependingKeyPathComponent:property.name];
                    }
                    return NO;
                }
                if (![value isEqual:[self valueForKey:property.name]]) {
                    [self setValue:value forKey: property.name];
                }
                
                //for clarity, does the same without continue
                continue;

            }
            else {
                // 检查是否遵循其他协议<数组>
                if (property.protocol) {
                    jsonValue = [self __transform:jsonValue forProperty:property error:err];
                    if (!jsonValue) {
                        if ((err != nil) && (*err == nil)) {
                            NSString* msg = [NSString stringWithFormat:@"Failed to transform value, but no error was set during transformation. (%@)", property];
                            JSONModelError* dataErr = [JSONModelError errorInvalidDataWithMessage:msg];
                            *err = [dataErr errorByPrependingKeyPathComponent:property.name];
                        }
                        return NO;
                    }
                }
                
                // 3.1) handle matching standard JSON types
                // 标准JSON类型直接赋值
                if (property.isStandardJSONType && [jsonValue isKindOfClass: property.type]) {
                    
                    //mutable properties
                    if (property.isMutable) {
                        jsonValue = [jsonValue mutableCopy];
                    }

                    //set the property value
                    if (![jsonValue isEqual:[self valueForKey:property.name]]) {
                        [self setValue:jsonValue forKey: property.name];
                    }
                    continue;
                }

                // 3.3) handle values to transform
                // 处理 可变类型 struct 以及不能转换的类型
                if ((![jsonValue isKindOfClass:property.type] && !isNull(jsonValue))
                    ||
                    //the property is mutable
                    property.isMutable
                    ||
                    //custom struct property
                    property.structName
                    ) {

                    // searched around the web how to do this better
                    // but did not find any solution, maybe that's the best idea? (hardly)
                    Class sourceClass = [JSONValueTransformer classByResolvingClusterClasses:[jsonValue class]];
                    
                    //JMLog(@"to type: [%@] from type: [%@] transformer: [%@]", p.type, sourceClass, selectorName);

                    //build a method selector for the property and json object classes
                    NSString* selectorName = [NSString stringWithFormat:@"%@From%@:",
                                              (property.structName? property.structName : property.type), //target name
                                              sourceClass]; //source name
                    SEL selector = NSSelectorFromString(selectorName);

                    //check for custom transformer
                    BOOL foundCustomTransformer = NO;
                    if ([valueTransformer respondsToSelector:selector]) {
                        foundCustomTransformer = YES;
                    }
                    else {
                        //try for hidden custom transformer
                        selectorName = [NSString stringWithFormat:@"__%@",selectorName];
                        selector = NSSelectorFromString(selectorName);
                        if ([valueTransformer respondsToSelector:selector]) {
                            foundCustomTransformer = YES;
                        }
                    }

                    //check if there's a transformer with that name
                    if (foundCustomTransformer) {

                        //it's OK, believe me...
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        //transform the value
                        jsonValue = [valueTransformer performSelector:selector withObject:jsonValue];
#pragma clang diagnostic pop

                        if (![jsonValue isEqual:[self valueForKey:property.name]]) {
                            [self setValue:jsonValue forKey: property.name];
                        }

                    } else {
                        NSString* msg = [NSString stringWithFormat:@"%@ type not supported for %@.%@", property.type, [self class], property.name];
                        JSONModelError* dataErr = [JSONModelError errorInvalidDataWithTypeMismatch:msg];
                        *err = [dataErr errorByPrependingKeyPathComponent:property.name];
                        return NO;
                    }

                }
                else {
                    // 3.4) handle "all other" cases (if any)
                    if (![jsonValue isEqual:[self valueForKey:property.name]]) {
                        [self setValue:jsonValue forKey: property.name];
                    }
                }
            }
        }
    }

    return YES;
}

#pragma mark - property inspection methods

- (BOOL)__isJSONModelSubClass:(Class)class {
// http://stackoverflow.com/questions/19883472/objc-nsobject-issubclassofclass-gives-incorrect-failure
#ifdef UNIT_TESTING
    return [@"JSONModel" isEqualToString: NSStringFromClass([class superclass])];
#else
    return [class isSubclassOfClass:JSONModelClass];
#endif
}

//returns a set of the required keys for the model
- (NSMutableSet*)__requiredPropertyNames {
    //fetch the associated property names
    NSMutableSet* classRequiredPropertyNames = objc_getAssociatedObject(self.class, &kClassRequiredPropertyNamesKey);
    
    if (!classRequiredPropertyNames) {
        classRequiredPropertyNames = [NSMutableSet set];
        [[self __properties__] enumerateObjectsUsingBlock:^(JSONModelClassProperty* p, NSUInteger idx, BOOL *stop) {
            if (!p.isOptional) [classRequiredPropertyNames addObject:p.name];
        }];
        
        //persist the list
        objc_setAssociatedObject(
                                 self.class,
                                 &kClassRequiredPropertyNamesKey,
                                 classRequiredPropertyNames,
                                 OBJC_ASSOCIATION_RETAIN // This is atomic
                                 );
    }
    return classRequiredPropertyNames;
}

//returns a list of the model's properties
- (NSArray*)__properties__ {
    //fetch the associated object
    NSDictionary* classProperties = objc_getAssociatedObject(self.class, &kClassPropertiesKey);
    if (classProperties) return [classProperties allValues];

    //if here, the class needs to inspect itself
    [self __setup__];

    //return the property list
    classProperties = objc_getAssociatedObject(self.class, &kClassPropertiesKey);
    return [classProperties allValues];
}

//inspects the class, get's a list of the class properties
/// 检查这个类，获取这个类的属性集合
- (void)__inspectProperties {
    NSMutableDictionary* propertyIndex = [NSMutableDictionary dictionary];

    //temp variables for the loops
    Class class = [self class];
    NSScanner* scanner = nil;
    NSString* propertyType = nil;

    // inspect inherited properties up to the JSONModel class
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    while (class != [JSONModel class]) {
        //JMLog(@"inspecting: %@", NSStringFromClass(class));

        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);

        for (unsigned int i = 0; i < propertyCount; i++) {

            // 创建一个对象，保存某个属性的相关信息
            JSONModelClassProperty* p = [[JSONModelClassProperty alloc] init];
            
            // 获取属性名
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            p.name = @(propertyName);


            // 获取属性的属性
            const char *attrs = property_getAttributes(property);
            NSString* propertyAttributes = @(attrs);
            NSArray* attributeItems = [propertyAttributes componentsSeparatedByString:@","];

            //ignore read-only properties
            if ([attributeItems containsObject:@"R"]) {
                continue; //to next property
            }

            //check for 64b BOOLs
            if ([propertyAttributes hasPrefix:@"Tc,"]) {
                //mask BOOLs as structs so they can have custom converters
                p.structName = @"BOOL";
            }
             
            scanner = [NSScanner scannerWithString: propertyAttributes];

            // 扫描到 "T" 的话，停下来
            [scanner scanUpToString:@"T" intoString: nil];
            [scanner scanString:@"T" intoString:nil];
            
            //check if the property is an instance of a class
            // 检测该属性是否是某个类的实例
            if ([scanner scanString:@"@\"" intoString: &propertyType]) {
                
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                        intoString:&propertyType];

                // 获取属性的类型
                p.type = NSClassFromString(propertyType);
                // 获取是否是可变类型
                p.isMutable = ([propertyType rangeOfString:@"Mutable"].location != NSNotFound);
                // 是否是标准的类型
                p.isStandardJSONType = [allowedJSONTypes containsObject:p.type];

                // 检查属性后面是否跟了协议
                while ([scanner scanString:@"<" intoString:NULL]) {

                    NSString* protocolName = nil;
                    
                    [scanner scanUpToString:@">" intoString: &protocolName];
                    
                    // TODO:zhuhoulin，为什么这里用optional来判断
                    if ([protocolName isEqualToString:@"Optional"]) {
                        p.isOptional = YES;
                    }
                    else if([protocolName isEqualToString:@"Index"]) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                        p.isIndex = YES;
#pragma GCC diagnostic pop

                        objc_setAssociatedObject(
                                                 self.class,
                                                 &kIndexPropertyNameKey,
                                                 p.name,
                                                 OBJC_ASSOCIATION_RETAIN // This is atomic
                                                 );
                    }
                    else if([protocolName isEqualToString:@"Ignore"]) {
                        p = nil;
                    }
                    else {
                        p.protocol = protocolName;
                    }
                    
                    [scanner scanString:@">" intoString:NULL];
                }

            }
            //check if the property is a structure
            // 检测该属性是否是一个结构体
            else if ([scanner scanString:@"{" intoString: &propertyType]) {
                [scanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet]
                                    intoString:&propertyType];

                p.isStandardJSONType = NO;
                p.structName = propertyType;
            }
            //the property must be a primitive
            // 剩余的属性，都是一些基础类型
            else {

                //the property contains a primitive data type
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","]
                                        intoString:&propertyType];

                //get the full name of the primitive type
                propertyType = valueTransformer.primitivesNames[propertyType];

                // 如果基础的数据类型中没有的话，直接报错
                if (![allowedPrimitiveTypes containsObject:propertyType]) {

                    //type not allowed - programmer mistaken -> exception
                    @throw [NSException exceptionWithName:@"JSONModelProperty type not allowed"
                                                   reason:[NSString stringWithFormat:@"Property type of %@.%@ is not supported by JSONModel.", self.class, p.name]
                                                 userInfo:nil];
                }
            }
            
            NSString *nsPropertyName = @(propertyName);
            
            // 可选属性<Optional>
            if([[self class] propertyIsOptional:nsPropertyName]){
                p.isOptional = YES;
            }
            
            // 属性可忽略。为什么要有这个东西呢？原因是方法‘-(BOOL)__doesDictionary:(NSDictionary*)dict matchModelWithKeyMapper:(JSONKeyMapper*)keyMapper error:(NSError**)err’中，如果self中的propertyName在JSON中是不存在的，那么这个转换会直接失败。所以需要'propertyIsIgnored'这个方法，将p设置为nil。讲道理这里的设计并不好
            if([[self class] propertyIsIgnored:nsPropertyName]){
                p = nil;
            }
            
            Class customClass = [[self class] classForCollectionProperty:nsPropertyName];
            if (customClass) {
                p.protocol = NSStringFromClass(customClass);
            }
            
            //few cases where JSONModel will ignore properties automatically
            // 如果属性是block类型，直接设置为nil
            if ([propertyType isEqualToString:@"Block"]) {
                p = nil;
            }

            // add the property object to the temp index
            if (p && ![propertyIndex objectForKey:p.name]) {
                [propertyIndex setValue:p forKey:p.name];
            }
            
            // generate custom setters and getter
            if (p) {
                // 属性首字符大写
                NSString *name = [p.name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[p.name substringToIndex:1].uppercaseString];

                // 自定义getter方法
                SEL getter = NSSelectorFromString([NSString stringWithFormat:@"JSONObjectFor%@", name]);

                if ([self respondsToSelector:getter]) {
                    p.customGetter = getter;
                }

                // 自定义setter方法
                p.customSetters = [NSMutableDictionary new];

                SEL genericSetter = NSSelectorFromString([NSString stringWithFormat:@"set%@WithJSONObject:", name]);
                
                if ([self respondsToSelector:genericSetter]) {
                    p.customSetters[@"generic"] = [NSValue valueWithBytes:&genericSetter objCType:@encode(SEL)];
                }
                
                for (Class type in allowedJSONTypes) {
                    NSString *class = NSStringFromClass([JSONValueTransformer classByResolvingClusterClasses:type]);
                    
                    if (p.customSetters[class]) {
                        continue;
                    }
                    
                    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@With%@:", name, class]);
                    
                    if ([self respondsToSelector:setter]) {
                        p.customSetters[class] = [NSValue valueWithBytes:&setter objCType:@encode(SEL)];
                    }
                }
            }
        }

        // 释放
        free(properties);

        //ascend to the super of the class
        //(will do that until it reaches the root class - JSONModel)
        // 逐级查找
        class = [class superclass];
    }

    //finally store the property index in the static property index
    objc_setAssociatedObject(self.class,
                             &kClassPropertiesKey,
                             [propertyIndex copy],
                             OBJC_ASSOCIATION_RETAIN // This is atomic
                             );
}

#pragma mark - built-in transformer methods
//few built-in transformations
-(id)__transform:(id)value forProperty:(JSONModelClassProperty*)property error:(NSError**)err {
    Class protocolClass = NSClassFromString(property.protocol);
    if (!protocolClass) {

        //no other protocols on arrays and dictionaries
        //except JSONModel classes
        if ([value isKindOfClass:[NSArray class]]) {
            @throw [NSException exceptionWithName:@"Bad property protocol declaration"
                                           reason:[NSString stringWithFormat:@"<%@> is not allowed JSONModel property protocol, and not a JSONModel class.", property.protocol]
                                         userInfo:nil];
        }
        return value;
    }

    //if the protocol is actually a JSONModel class
    if ([self __isJSONModelSubClass:protocolClass]) {

        //check if it's a list of models
        if ([property.type isSubclassOfClass:[NSArray class]]) {

            // Expecting an array, make sure 'value' is an array
            if(![[value class] isSubclassOfClass:[NSArray class]])
            {
                if(err != nil)
                {
                    NSString* mismatch = [NSString stringWithFormat:@"Property '%@' is declared as NSArray<%@>* but the corresponding JSON value is not a JSON Array.", property.name, property.protocol];
                    JSONModelError* typeErr = [JSONModelError errorInvalidDataWithTypeMismatch:mismatch];
                    *err = [typeErr errorByPrependingKeyPathComponent:property.name];
                }
                return nil;
            }

            //one shot conversion
            JSONModelError* arrayErr = nil;
            value = [[protocolClass class] arrayOfModelsFromDictionaries:value error:&arrayErr];
            if((err != nil) && (arrayErr != nil))
            {
                *err = [arrayErr errorByPrependingKeyPathComponent:property.name];
                return nil;
            }
        }

        //check if it's a dictionary of models
        if ([property.type isSubclassOfClass:[NSDictionary class]]) {

            // Expecting a dictionary, make sure 'value' is a dictionary
            if(![[value class] isSubclassOfClass:[NSDictionary class]])
            {
                if(err != nil)
                {
                    NSString* mismatch = [NSString stringWithFormat:@"Property '%@' is declared as NSDictionary<%@>* but the corresponding JSON value is not a JSON Object.", property.name, property.protocol];
                    JSONModelError* typeErr = [JSONModelError errorInvalidDataWithTypeMismatch:mismatch];
                    *err = [typeErr errorByPrependingKeyPathComponent:property.name];
                }
                return nil;
            }

            NSMutableDictionary* res = [NSMutableDictionary dictionary];

            for (NSString* key in [value allKeys]) {
                JSONModelError* initErr = nil;
                id obj = [[[protocolClass class] alloc] initWithDictionary:value[key] error:&initErr];
                if (obj == nil)
                {
                    // Propagate the error, including the property name as the key-path component
                    if((err != nil) && (initErr != nil))
                    {
                        initErr = [initErr errorByPrependingKeyPathComponent:key];
                        *err = [initErr errorByPrependingKeyPathComponent:property.name];
                    }
                    return nil;
                }
                [res setValue:obj forKey:key];
            }
            value = [NSDictionary dictionaryWithDictionary:res];
        }
    }

    return value;
}

//built-in reverse transformations (export to JSON compliant objects)
- (id)__reverseTransform:(id)value forProperty:(JSONModelClassProperty*)property {
    Class protocolClass = NSClassFromString(property.protocol);
    if (!protocolClass) return value;

    //if the protocol is actually a JSONModel class
    if ([self __isJSONModelSubClass:protocolClass]) {

        //check if should export list of dictionaries
        if (property.type == [NSArray class] || property.type == [NSMutableArray class]) {
            NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity: [(NSArray*)value count] ];
            for (NSObject<AbstractJSONModelProtocol>* model in (NSArray*)value) {
                if ([model respondsToSelector:@selector(toDictionary)]) {
                    [tempArray addObject: [model toDictionary]];
                } else
                    [tempArray addObject: model];
            }
            return [tempArray copy];
        }

        //check if should export dictionary of dictionaries
        if (property.type == [NSDictionary class] || property.type == [NSMutableDictionary class]) {
            NSMutableDictionary* res = [NSMutableDictionary dictionary];
            for (NSString* key in [(NSDictionary*)value allKeys]) {
                id<AbstractJSONModelProtocol> model = value[key];
                [res setValue: [model toDictionary] forKey: key];
            }
            return [NSDictionary dictionaryWithDictionary:res];
        }
    }

    return value;
}

#pragma mark - custom transformations
- (BOOL)__customSetValue:(id <NSObject>)value forProperty:(JSONModelClassProperty *)property {
    NSString *class = NSStringFromClass([JSONValueTransformer classByResolvingClusterClasses:[value class]]);

    SEL setter = nil;
    [property.customSetters[class] getValue:&setter];
    
    if (!setter)
        [property.customSetters[@"generic"] getValue:&setter];

    if (!setter)
        return NO;

    IMP imp = [self methodForSelector:setter];
    void (*func)(id, SEL, id <NSObject>) = (void *)imp;
    func(self, setter, value);

    return YES;
}

- (BOOL)__customGetValue:(id *)value forProperty:(JSONModelClassProperty *)property {
    SEL getter = property.customGetter;

    if (!getter)
        return NO;

    IMP imp = [self methodForSelector:getter];
    id (*func)(id, SEL) = (void *)imp;
    *value = func(self, getter);

    return YES;
}

#pragma mark - persistance
- (void)__createDictionariesForKeyPath:(NSString*)keyPath inDictionary:(NSMutableDictionary**)dict {
    //find if there's a dot left in the keyPath
    NSUInteger dotLocation = [keyPath rangeOfString:@"."].location;
    if (dotLocation==NSNotFound) return;

    //inspect next level
    NSString* nextHierarchyLevelKeyName = [keyPath substringToIndex: dotLocation];
    NSDictionary* nextLevelDictionary = (*dict)[nextHierarchyLevelKeyName];

    if (nextLevelDictionary==nil) {
        //create non-existing next level here
        nextLevelDictionary = [NSMutableDictionary dictionary];
    }

    //recurse levels
    [self __createDictionariesForKeyPath:[keyPath substringFromIndex: dotLocation+1]
                            inDictionary:&nextLevelDictionary ];

    //create the hierarchy level
    [*dict setValue:nextLevelDictionary  forKeyPath: nextHierarchyLevelKeyName];
}

- (NSDictionary*)toDictionary {
    return [self toDictionaryWithKeys:nil];
}

- (NSString*)toJSONString {
    return [self toJSONStringWithKeys:nil];
}

- (NSData*)toJSONData {
    return [self toJSONDataWithKeys:nil];
}

//exports the model as a dictionary of JSON compliant objects
- (NSDictionary*)toDictionaryWithKeys:(NSArray*)propertyNames {
    NSArray* properties = [self __properties__];
    NSMutableDictionary* tempDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];

    id value;

    //loop over all properties
    for (JSONModelClassProperty* p in properties) {

        //skip if unwanted
        if (propertyNames != nil && ![propertyNames containsObject:p.name])
            continue;

        //fetch key and value
        NSString* keyPath = (self.__keyMapper||globalKeyMapper) ? [self __mapString:p.name withKeyMapper:self.__keyMapper] : p.name;
        value = [self valueForKey: p.name];

        //JMLog(@"toDictionary[%@]->[%@] = '%@'", p.name, keyPath, value);

        if ([keyPath rangeOfString:@"."].location != NSNotFound) {
            //there are sub-keys, introduce dictionaries for them
            [self __createDictionariesForKeyPath:keyPath inDictionary:&tempDictionary];
        }

        //check for custom getter
        if ([self __customGetValue:&value forProperty:p]) {
            //custom getter, all done
            [tempDictionary setValue:value forKeyPath:keyPath];
            continue;
        }

        //export nil when they are not optional values as JSON null, so that the structure of the exported data
        //is still valid if it's to be imported as a model again
        if (isNull(value)) {

            if (value == nil)
            {
                [tempDictionary removeObjectForKey:keyPath];
            }
            else
            {
                [tempDictionary setValue:[NSNull null] forKeyPath:keyPath];
            }
            continue;
        }

        //check if the property is another model
        if ([value isKindOfClass:JSONModelClass]) {

            //recurse models
            value = [(JSONModel*)value toDictionary];
            [tempDictionary setValue:value forKeyPath: keyPath];

            //for clarity
            continue;

        } else {

            // 1) check for built-in transformation
            if (p.protocol) {
                value = [self __reverseTransform:value forProperty:p];
            }

            // 2) check for standard types OR 2.1) primitives
            if (p.structName==nil && (p.isStandardJSONType || p.type==nil)) {

                //generic get value
                [tempDictionary setValue:value forKeyPath: keyPath];

                continue;
            }

            // 3) try to apply a value transformer
            if (YES) {

                //create selector from the property's class name
                NSString* selectorName = [NSString stringWithFormat:@"%@From%@:", @"JSONObject", p.type?p.type:p.structName];
                SEL selector = NSSelectorFromString(selectorName);

                BOOL foundCustomTransformer = NO;
                if ([valueTransformer respondsToSelector:selector]) {
                    foundCustomTransformer = YES;
                } else {
                    //try for hidden transformer
                    selectorName = [NSString stringWithFormat:@"__%@",selectorName];
                    selector = NSSelectorFromString(selectorName);
                    if ([valueTransformer respondsToSelector:selector]) {
                        foundCustomTransformer = YES;
                    }
                }

                //check if there's a transformer declared
                if (foundCustomTransformer) {

                    //it's OK, believe me...
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    value = [valueTransformer performSelector:selector withObject:value];
#pragma clang diagnostic pop

                    [tempDictionary setValue:value forKeyPath: keyPath];

                } else {

                    //in this case most probably a custom property was defined in a model
                    //but no default reverse transformer for it
                    @throw [NSException exceptionWithName:@"Value transformer not found"
                                                   reason:[NSString stringWithFormat:@"[JSONValueTransformer %@] not found", selectorName]
                                                 userInfo:nil];
                    return nil;
                }
            }
        }
    }

    return [tempDictionary copy];
}

//exports model to a dictionary and then to a JSON string
- (NSData*)toJSONDataWithKeys:(NSArray*)propertyNames {
    NSData* jsonData = nil;
    NSError* jsonError = nil;

    @try {
        NSDictionary* dict = [self toDictionaryWithKeys:propertyNames];
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&jsonError];
    }
    @catch (NSException *exception) {
        //this should not happen in properly design JSONModel
        //usually means there was no reverse transformer for a custom property
        JMLog(@"EXCEPTION: %@", exception.description);
        return nil;
    }

    return jsonData;
}

- (NSString*)toJSONStringWithKeys:(NSArray*)propertyNames {
    return [[NSString alloc] initWithData: [self toJSONDataWithKeys: propertyNames]
                                 encoding: NSUTF8StringEncoding];
}

#pragma mark - import/export of lists
//loop over an NSArray of JSON objects and turn them into models
+ (NSMutableArray*)arrayOfModelsFromDictionaries:(NSArray*)array {
    return [self arrayOfModelsFromDictionaries:array error:nil];
}

+ (NSMutableArray *)arrayOfModelsFromData:(NSData *)data error:(NSError **)err {
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:err];
    if (!json || ![json isKindOfClass:[NSArray class]]) return nil;

    return [self arrayOfModelsFromDictionaries:json error:err];
}

+ (NSMutableArray *)arrayOfModelsFromString:(NSString *)string error:(NSError **)err {
    return [self arrayOfModelsFromData:[string dataUsingEncoding:NSUTF8StringEncoding] error:err];
}

// Same as above, but with error reporting
+ (NSMutableArray*)arrayOfModelsFromDictionaries:(NSArray*)array error:(NSError**)err {
    //bail early
    if (isNull(array)) return nil;

    //parse dictionaries to objects
    NSMutableArray* list = [NSMutableArray arrayWithCapacity: [array count]];

    for (id d in array)
    {
        if ([d isKindOfClass:NSDictionary.class])
        {
            JSONModelError* initErr = nil;
            id obj = [[self alloc] initWithDictionary:d error:&initErr];
            if (obj == nil)
            {
                // Propagate the error, including the array index as the key-path component
                if((err != nil) && (initErr != nil))
                {
                    NSString* path = [NSString stringWithFormat:@"[%lu]", (unsigned long)list.count];
                    *err = [initErr errorByPrependingKeyPathComponent:path];
                }
                return nil;
            }

            [list addObject: obj];
        } else if ([d isKindOfClass:NSArray.class])
        {
            [list addObjectsFromArray:[self arrayOfModelsFromDictionaries:d error:err]];
        } else
        {
            // This is very bad
        }

    }

    return list;
}

+ (NSMutableDictionary *)dictionaryOfModelsFromString:(NSString *)string error:(NSError **)err {
    return [self dictionaryOfModelsFromData:[string dataUsingEncoding:NSUTF8StringEncoding] error:err];
}

+ (NSMutableDictionary *)dictionaryOfModelsFromData:(NSData *)data error:(NSError **)err {
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:err];
    if (!json || ![json isKindOfClass:[NSDictionary class]]) return nil;

    return [self dictionaryOfModelsFromDictionary:json error:err];
}

+ (NSMutableDictionary *)dictionaryOfModelsFromDictionary:(NSDictionary *)dictionary error:(NSError **)err {
    NSMutableDictionary *output = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];

    for (NSString *key in dictionary.allKeys)
    {
        id object = dictionary[key];

        if ([object isKindOfClass:NSDictionary.class])
        {
            id obj = [[self alloc] initWithDictionary:object error:err];
            if (obj == nil) return nil;
            output[key] = obj;
        }
        else if ([object isKindOfClass:NSArray.class])
        {
            id obj = [self arrayOfModelsFromDictionaries:object error:err];
            if (obj == nil) return nil;
            output[key] = obj;
        }
        else
        {
            *err = [JSONModelError errorInvalidDataWithTypeMismatch:@"Only dictionaries and arrays are supported"];
            return nil;
        }
    }

    return output;
}

//loop over NSArray of models and export them to JSON objects
+ (NSMutableArray *)arrayOfDictionariesFromModels:(NSArray*)array {
    //bail early
    if (isNull(array)) return nil;

    //convert to dictionaries
    NSMutableArray* list = [NSMutableArray arrayWithCapacity: [array count]];

    for (id<AbstractJSONModelProtocol> object in array) {

        id obj = [object toDictionary];
        if (!obj) return nil;

        [list addObject: obj];
    }
    return list;
}

//loop over NSArray of models and export them to JSON objects with specific properties
+ (NSMutableArray*)arrayOfDictionariesFromModels:(NSArray*)array propertyNamesToExport:(NSArray*)propertyNamesToExport; {
    //bail early
    if (isNull(array)) return nil;

    //convert to dictionaries
    NSMutableArray* list = [NSMutableArray arrayWithCapacity: [array count]];

    for (id<AbstractJSONModelProtocol> object in array) {

        id obj = [object toDictionaryWithKeys:propertyNamesToExport];
        if (!obj) return nil;

        [list addObject: obj];
    }
    return list;
}

+ (NSMutableDictionary *)dictionaryOfDictionariesFromModels:(NSDictionary *)dictionary {
    //bail early
    if (isNull(dictionary)) return nil;

    NSMutableDictionary *output = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];

    for (NSString *key in dictionary.allKeys) {
        id <AbstractJSONModelProtocol> object = dictionary[key];
        id obj = [object toDictionary];
        if (!obj) return nil;
        output[key] = obj;
    }

    return output;
}

#pragma mark - custom comparison methods

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (NSString*)indexPropertyName {
    //custom getter for an associated object
    return objc_getAssociatedObject(self.class, &kIndexPropertyNameKey);
}

- (BOOL)isEqual:(id)object {
    //bail early if different classes
    if (![object isMemberOfClass:[self class]]) return NO;

    if (self.indexPropertyName) {
        //there's a defined ID property
        id objectId = [object valueForKey: self.indexPropertyName];
        return [[self valueForKey: self.indexPropertyName] isEqual:objectId];
    }

    //default isEqual implementation
    return [super isEqual:object];
}

- (NSComparisonResult)compare:(id)object {
    if (self.indexPropertyName) {
        id objectId = [object valueForKey: self.indexPropertyName];
        if ([objectId respondsToSelector:@selector(compare:)]) {
            return [[self valueForKey:self.indexPropertyName] compare:objectId];
        }
    }

    //on purpose postponing the asserts for speed optimization
    //these should not happen anyway in production conditions
    NSAssert(self.indexPropertyName, @"Can't compare models with no <Index> property");
    NSAssert1(NO, @"The <Index> property of %@ is not comparable class.", [self class]);
    return kNilOptions;
}

- (NSUInteger)hash {
    if (self.indexPropertyName) {
        id val = [self valueForKey:self.indexPropertyName];

        if (val) {
            return [val hash];
        }
    }

    return [super hash];
}

#pragma GCC diagnostic pop

#pragma mark - custom data validation
- (BOOL)validate:(NSError**)error {
    return YES;
}

#pragma mark - custom recursive description
//custom description method for debugging purposes
- (NSString*)description {
    NSMutableString* text = [NSMutableString stringWithFormat:@"<%@> \n", [self class]];

    for (JSONModelClassProperty *p in [self __properties__]) {

        id value = ([p.name isEqualToString:@"description"])?self->_description:[self valueForKey:p.name];
        NSString* valueDescription = (value)?[value description]:@"<nil>";

        if (p.isStandardJSONType && ![value respondsToSelector:@selector(count)] && [valueDescription length]>60) {

            //cap description for longer values
            valueDescription = [NSString stringWithFormat:@"%@...", [valueDescription substringToIndex:59]];
        }
        valueDescription = [valueDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
        [text appendFormat:@"   [%@]: %@\n", p.name, valueDescription];
    }

    [text appendFormat:@"</%@>", [self class]];
    return text;
}

#pragma mark - key mapping
+(JSONKeyMapper*)keyMapper {
    return nil;
}

+(void)setGlobalKeyMapper:(JSONKeyMapper*)globalKeyMapperParam {
    globalKeyMapper = globalKeyMapperParam;
}


/// 子类重新，哪个属性是可选，哪个是不可选
+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return NO;
}

+(BOOL)propertyIsIgnored:(NSString *)propertyName {
    return NO;
}

+(NSString*)protocolForArrayProperty:(NSString *)propertyName {
    return nil;
}

+(Class)classForCollectionProperty:(NSString *)propertyName
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    NSString *protocolName = [self protocolForArrayProperty:propertyName];
#pragma GCC diagnostic pop

    if (!protocolName)
        return nil;

    return NSClassFromString(protocolName);
}

#pragma mark - working with incomplete models
- (void)mergeFromDictionary:(NSDictionary *)dict useKeyMapping:(BOOL)useKeyMapping {
    [self mergeFromDictionary:dict useKeyMapping:useKeyMapping error:nil];
}

- (BOOL)mergeFromDictionary:(NSDictionary *)dict useKeyMapping:(BOOL)useKeyMapping error:(NSError **)error {
    return [self __importDictionary:dict withKeyMapper:(useKeyMapping)? self.__keyMapper:nil validation:NO error:error];
}

#pragma mark - NSCopying, NSCoding
- (instancetype)copyWithZone:(NSZone *)zone {
    return [NSKeyedUnarchiver unarchiveObjectWithData:
        [NSKeyedArchiver archivedDataWithRootObject:self]
     ];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    NSString* json;

    if ([decoder respondsToSelector:@selector(decodeObjectOfClass:forKey:)]) {
        json = [decoder decodeObjectOfClass:[NSString class] forKey:@"json"];
    } else {
        json = [decoder decodeObjectForKey:@"json"];
    }

    JSONModelError *error = nil;
    self = [self initWithString:json error:&error];
    if (error) {
        JMLog(@"%@",[error localizedDescription]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.toJSONString forKey:@"json"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
