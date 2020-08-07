
#ifndef _REWRITER_typedef_A
#define _REWRITER_typedef_A
typedef struct objc_object A;
typedef struct {} _objc_exc_A;
#endif

struct A_IMPL {
	struct NSObject_IMPL NSObject_IVARS;
};


/* @end */


// @implementation A


// @end


#ifndef _REWRITER_typedef_B
#define _REWRITER_typedef_B
typedef struct objc_object B;
typedef struct {} _objc_exc_B;
#endif

struct B_IMPL {
	struct A_IMPL A_IVARS;
};


/* @end */


// @implementation B


// @end


#ifndef _REWRITER_typedef_C
#define _REWRITER_typedef_C
typedef struct objc_object C;
typedef struct {} _objc_exc_C;
#endif

struct C_IMPL {
	struct B_IMPL B_IVARS;
};


/* @end */


// @implementation C


// @end


int main(int argc, char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 






        A *a = ((A *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("A"), sel_registerName("new"));
        B *b = ((B *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("B"), sel_registerName("new"));
        C *c = ((C *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("C"), sel_registerName("new"));

    }
    return 0;
}

struct _prop_t {
	const char *name;
	const char *attributes;
};

struct _protocol_t;

struct _objc_method {
	struct objc_selector * _cmd;
	const char *method_type;
	void  *_imp;
};

struct _protocol_t {
	void * isa;  // NULL
	const char *protocol_name;
	const struct _protocol_list_t * protocol_list; // super protocols
	const struct method_list_t *instance_methods;
	const struct method_list_t *class_methods;
	const struct method_list_t *optionalInstanceMethods;
	const struct method_list_t *optionalClassMethods;
	const struct _prop_list_t * properties;
	const unsigned int size;  // sizeof(struct _protocol_t)
	const unsigned int flags;  // = 0
	const char ** extendedMethodTypes;
};

struct _ivar_t {
	unsigned long int *offset;  // pointer to ivar offset location
	const char *name;
	const char *type;
	unsigned int alignment;
	unsigned int  size;
};

// 存储了当前类在编译期就已经确定的属性、方法以及遵循的协议
struct _class_ro_t {
	unsigned int flags;
	unsigned int instanceStart;
	unsigned int instanceSize;
	unsigned int reserved;
	const unsigned char *ivarLayout;
	const char *name;
	const struct _method_list_t *baseMethods;
	const struct _objc_protocol_list *baseProtocols;
	const struct _ivar_list_t *ivars;
	const unsigned char *weakIvarLayout;
	const struct _prop_list_t *properties;
};

struct _class_t {
	struct _class_t *isa;
	struct _class_t *superclass;
	void *cache;
	void *vtable;
	struct _class_ro_t *ro;
};

struct _category_t {
	const char *name;
	struct _class_t *cls;
	const struct _method_list_t *instance_methods;
	const struct _method_list_t *class_methods;
	const struct _protocol_list_t *protocols;
	const struct _prop_list_t *properties;
};

extern "C" __declspec(dllimport) struct objc_cache _objc_empty_cache;
#pragma warning(disable:4273)

static struct _class_ro_t _OBJC_METACLASS_RO_$_A __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	1, sizeof(struct _class_t), sizeof(struct _class_t), 
	(unsigned int)0, 
	0, 
	"A",
	0, 
	0, 
	0, 
	0, 
	0, 
};

static struct _class_ro_t _OBJC_CLASS_RO_$_A __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	0, sizeof(struct A_IMPL), sizeof(struct A_IMPL), 
	(unsigned int)0, 
	0, 
	"A",
	0, 
	0, 
	0, 
	0, 
	0, 
};

extern "C" __declspec(dllimport) struct _class_t OBJC_METACLASS_$_NSObject;

extern "C" __declspec(dllexport) struct _class_t OBJC_METACLASS_$_A __attribute__ ((used, section ("__DATA,__objc_data"))) = {
	0, // &OBJC_METACLASS_$_NSObject,
	0, // &OBJC_METACLASS_$_NSObject,
	0, // (void *)&_objc_empty_cache,
	0, // unused, was (void *)&_objc_empty_vtable,
	&_OBJC_METACLASS_RO_$_A,
};

extern "C" __declspec(dllimport) struct _class_t OBJC_CLASS_$_NSObject;

extern "C" __declspec(dllexport) struct _class_t OBJC_CLASS_$_A __attribute__ ((used, section ("__DATA,__objc_data"))) = {
	0, // &OBJC_METACLASS_$_A,
	0, // &OBJC_CLASS_$_NSObject,
	0, // (void *)&_objc_empty_cache,
	0, // unused, was (void *)&_objc_empty_vtable,
	&_OBJC_CLASS_RO_$_A,
};
static void OBJC_CLASS_SETUP_$_A(void ) {
	OBJC_METACLASS_$_A.isa = &OBJC_METACLASS_$_NSObject;
	OBJC_METACLASS_$_A.superclass = &OBJC_METACLASS_$_NSObject;
	OBJC_METACLASS_$_A.cache = &_objc_empty_cache;
	OBJC_CLASS_$_A.isa = &OBJC_METACLASS_$_A;
	OBJC_CLASS_$_A.superclass = &OBJC_CLASS_$_NSObject;
	OBJC_CLASS_$_A.cache = &_objc_empty_cache;
}

static struct _class_ro_t _OBJC_METACLASS_RO_$_B __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	1, sizeof(struct _class_t), sizeof(struct _class_t), 
	(unsigned int)0, 
	0, 
	"B",
	0, 
	0, 
	0, 
	0, 
	0, 
};

static struct _class_ro_t _OBJC_CLASS_RO_$_B __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	0, sizeof(struct B_IMPL), sizeof(struct B_IMPL), 
	(unsigned int)0, 
	0, 
	"B",
	0, 
	0, 
	0, 
	0, 
	0, 
};

extern "C" __declspec(dllexport) struct _class_t OBJC_METACLASS_$_A;
extern "C" __declspec(dllimport) struct _class_t OBJC_METACLASS_$_NSObject;

extern "C" __declspec(dllexport) struct _class_t OBJC_METACLASS_$_B __attribute__ ((used, section ("__DATA,__objc_data"))) = {
	0, // &OBJC_METACLASS_$_NSObject,
	0, // &OBJC_METACLASS_$_A,
	0, // (void *)&_objc_empty_cache,
	0, // unused, was (void *)&_objc_empty_vtable,
	&_OBJC_METACLASS_RO_$_B,
};

extern "C" __declspec(dllexport) struct _class_t OBJC_CLASS_$_A;

extern "C" __declspec(dllexport) struct _class_t OBJC_CLASS_$_B __attribute__ ((used, section ("__DATA,__objc_data"))) = {
	0, // &OBJC_METACLASS_$_B,
	0, // &OBJC_CLASS_$_A,
	0, // (void *)&_objc_empty_cache,
	0, // unused, was (void *)&_objc_empty_vtable,
	&_OBJC_CLASS_RO_$_B,
};
static void OBJC_CLASS_SETUP_$_B(void ) {
	OBJC_METACLASS_$_B.isa = &OBJC_METACLASS_$_NSObject;
	OBJC_METACLASS_$_B.superclass = &OBJC_METACLASS_$_A;
	OBJC_METACLASS_$_B.cache = &_objc_empty_cache;
	OBJC_CLASS_$_B.isa = &OBJC_METACLASS_$_B;
	OBJC_CLASS_$_B.superclass = &OBJC_CLASS_$_A;
	OBJC_CLASS_$_B.cache = &_objc_empty_cache;
}

static struct _class_ro_t _OBJC_METACLASS_RO_$_C __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	1, sizeof(struct _class_t), sizeof(struct _class_t), 
	(unsigned int)0, 
	0, 
	"C",
	0, 
	0, 
	0, 
	0, 
	0, 
};

static struct _class_ro_t _OBJC_CLASS_RO_$_C __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	0, sizeof(struct C_IMPL), sizeof(struct C_IMPL), 
	(unsigned int)0, 
	0, 
	"C",
	0, 
	0, 
	0, 
	0, 
	0, 
};

extern "C" __declspec(dllexport) struct _class_t OBJC_METACLASS_$_B;
extern "C" __declspec(dllimport) struct _class_t OBJC_METACLASS_$_NSObject;

extern "C" __declspec(dllexport) struct _class_t OBJC_METACLASS_$_C __attribute__ ((used, section ("__DATA,__objc_data"))) = {
	0, // &OBJC_METACLASS_$_NSObject,
	0, // &OBJC_METACLASS_$_B,
	0, // (void *)&_objc_empty_cache,
	0, // unused, was (void *)&_objc_empty_vtable,
	&_OBJC_METACLASS_RO_$_C,
};

extern "C" __declspec(dllexport) struct _class_t OBJC_CLASS_$_B;

extern "C" __declspec(dllexport) struct _class_t OBJC_CLASS_$_C __attribute__ ((used, section ("__DATA,__objc_data"))) = {
	0, // &OBJC_METACLASS_$_C,
	0, // &OBJC_CLASS_$_B,
	0, // (void *)&_objc_empty_cache,
	0, // unused, was (void *)&_objc_empty_vtable,
	&_OBJC_CLASS_RO_$_C,
};
static void OBJC_CLASS_SETUP_$_C(void ) {
	OBJC_METACLASS_$_C.isa = &OBJC_METACLASS_$_NSObject;
	OBJC_METACLASS_$_C.superclass = &OBJC_METACLASS_$_B;
	OBJC_METACLASS_$_C.cache = &_objc_empty_cache;
	OBJC_CLASS_$_C.isa = &OBJC_METACLASS_$_C;
	OBJC_CLASS_$_C.superclass = &OBJC_CLASS_$_B;
	OBJC_CLASS_$_C.cache = &_objc_empty_cache;
}
#pragma section(".objc_inithooks$B", long, read, write)
__declspec(allocate(".objc_inithooks$B")) static void *OBJC_CLASS_SETUP[] = {
	(void *)&OBJC_CLASS_SETUP_$_A,
	(void *)&OBJC_CLASS_SETUP_$_B,
	(void *)&OBJC_CLASS_SETUP_$_C,
};
static struct _class_t *L_OBJC_LABEL_CLASS_$ [3] __attribute__((used, section ("__DATA, __objc_classlist,regular,no_dead_strip")))= {
	&OBJC_CLASS_$_A,
	&OBJC_CLASS_$_B,
	&OBJC_CLASS_$_C,
};
static struct IMAGE_INFO { unsigned version; unsigned flag; } _OBJC_IMAGE_INFO = { 0, 2 };
