/*!
	@file		LWWatchFacePrototype.h
	@abstract	A watch face prototype used for testing
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWWatchFacePrototype.h"
#import <objc/runtime.h>
#import <LockWatchBase/LockWatchBase.h>
#import "NCMaterialView.h"
#import "CAKeyframeAnimation+AHEasing.h"

@implementation LWWatchFacePrototype

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
		[self->backgroundView setFrame:CGRectMake(-18, -18, 348, 426)];
		[self->backgroundView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.45]];
		[self->backgroundView.layer setCornerRadius:15.0];
		[self->backgroundView setClipsToBounds:YES];
		[self addSubview:self->backgroundView];
		
		UIView* testView = [Indicators indicatorsForSimpleWithDetail:1];
		[self addSubview:testView];
		
		[self setClipsToBounds:NO];
	}
	
	return self;
}

- (NCMaterialView*)backgroundView {
	return self->backgroundView;
}

- (void)fadeInWithContent:(BOOL)contentFade {
	[self.layer removeAllAnimations];
	[self->backgroundView.layer removeAllAnimations];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:0.0
															 toValue:1.0];
	opacity.duration = 0.3;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	opacity.beginTime = CACurrentMediaTime();
	
	if (contentFade) {
		[self.layer addAnimation:opacity forKey:@"opacity"];
	} else {
		[self->backgroundView.layer addAnimation:opacity forKey:@"opacity"];
	}
}

- (void)fadeOutWithContent:(BOOL)contentFade {
	[self.layer removeAllAnimations];
	[self->backgroundView.layer removeAllAnimations];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:1.0
															 toValue:0.0];
	opacity.duration = 0.3;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	opacity.beginTime = CACurrentMediaTime();
	
	if (contentFade) {
		[self.layer addAnimation:opacity forKey:@"opacity"];
	} else {
		[self->backgroundView.layer addAnimation:opacity forKey:@"opacity"];
	}
}

@end
