//
//  UIView+BlocksKit.m
//  BlocksKit
//

#import "UIGestureRecognizer+BlocksKit.h"
#import "UIView+BlocksKit.h"

@implementation UIView (BlocksKit)

- (void)bk_whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(void (^)(void))block
{
	if (!block) return;
	
    // 引用了局部变量，是一个NSStackBlock。后面会被复制到堆区，成为NSMallocBlock类型的block。作为临时变量，用完就销毁了。
    void (^actionBlock)(UIGestureRecognizer *, UIGestureRecognizerState, CGPoint) = ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
        if (state == UIGestureRecognizerStateRecognized) block();
    };
    
    NSLog(@"zhuhoulin:actionBlock----%@\n", actionBlock);
    
	UITapGestureRecognizer *gesture = [UITapGestureRecognizer bk_recognizerWithHandler:actionBlock];
	
	gesture.numberOfTouchesRequired = numberOfTouches;
	gesture.numberOfTapsRequired = numberOfTaps;

	[self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (![obj isKindOfClass:[UITapGestureRecognizer class]]) return;

		UITapGestureRecognizer *tap = obj;
		BOOL rightTouches = (tap.numberOfTouchesRequired == numberOfTouches);
		BOOL rightTaps = (tap.numberOfTapsRequired == numberOfTaps);
		if (rightTouches && rightTaps) {
			[gesture requireGestureRecognizerToFail:tap];
		}
	}];

	[self addGestureRecognizer:gesture];
}

- (void)bk_whenTapped:(void (^)(void))block
{
	[self bk_whenTouches:1 tapped:1 handler:block];
}

- (void)bk_whenDoubleTapped:(void (^)(void))block
{
	[self bk_whenTouches:2 tapped:1 handler:block];
}

- (void)bk_eachSubview:(void (^)(UIView *subview))block
{
	NSParameterAssert(block != nil);

	[self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
		block(subview);
	}];
}

@end
