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

#define scaleUpFactor (312.0/188.0)

@implementation LWWatchFacePrototype

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
		[self->backgroundView setFrame:CGRectMake(-18, -18, 348, 426)];
		[self->backgroundView setClipsToBounds:NO];
		[[[self->backgroundView subviews] objectAtIndex:0] setClipsToBounds:YES];
		[[[self->backgroundView subviews] objectAtIndex:0].layer setCornerRadius:15.0];
		
		[self addSubview:self->backgroundView];
		
		self->contentView = [Indicators indicatorsForSimpleWithDetail:0];
		[self addSubview:self->contentView];
		
		self->titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -70, 348, 50)];
		[self->titleLabel setText:[[NSString stringWithFormat:@"Prototype"] uppercaseString]];
		[self->titleLabel setTextColor:[UIColor whiteColor]];
		[self->titleLabel setTextAlignment:NSTextAlignmentCenter];
		[self->titleLabel setFont:[UIFont systemFontOfSize:24.0]];
		[self->titleLabel setTransform:CGAffineTransformMakeScale(scaleUpFactor, scaleUpFactor)];
		[self->backgroundView addSubview:self->titleLabel];
		
		[self setClipsToBounds:NO];
	}
	
	return self;
}

- (NCMaterialView*)backgroundView {
	return self->backgroundView;
}

- (void)setLevelOfDetail:(int)detail {
	[self->contentView removeFromSuperview];
	self->contentView = [Indicators indicatorsForSimpleWithDetail:detail];
	[self addSubview:self->contentView];
}

- (void)fadeInWithContent:(BOOL)contentFade {
	[self setAlpha:1.0];
	[self.layer removeAllAnimations];
	
	[self.backgroundView setAlpha:1.0];
	[self->backgroundView.layer removeAllAnimations];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:0.0
															 toValue:(contentFade?0.5:1.0)];
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
	[self setAlpha:1.0];
	[self.layer removeAllAnimations];
	
	[self.backgroundView setAlpha:1.0];
	[self->backgroundView.layer removeAllAnimations];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:(contentFade?0.5:1.0)
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

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
	return min + arc4random_uniform(max - min + 1);
}

@end
