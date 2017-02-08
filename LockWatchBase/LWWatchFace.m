//
//  LWWatchFace.m
//  LockWatch
//
//  Created by Janik Schmidt on 08.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "LWWatchFace.h"
#import "NCMaterialView.h"
#import "CAKeyframeAnimation+AHEasing.h"

#import <objc/runtime.h>

#define scaleUpFactor (312.0/188.0)

@implementation LWWatchFace

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		// Add a NCMaterialView to the background
		// This is currently iOS 10 only, but let's see how I get this done on iOS < 10
		self->backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
		[self->backgroundView setFrame:CGRectMake(-18, -18, 348, 426)];
		[self->backgroundView setClipsToBounds:NO];
		[[[self->backgroundView subviews] objectAtIndex:0] setClipsToBounds:YES];
		[[[self->backgroundView subviews] objectAtIndex:0].layer setCornerRadius:15.0];
		[self addSubview:self->backgroundView];
		
		self->contentView = [[UIView alloc] initWithFrame:CGRectZero];
		//[self addSubview:self->contentView];
		
		self->titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -70, 348, 50)];
		[self->titleLabel setTextColor:[UIColor whiteColor]];
		[self->titleLabel setTextAlignment:NSTextAlignmentCenter];
		[self->titleLabel setFont:[UIFont systemFontOfSize:24.0]];
		[self->titleLabel setTransform:CGAffineTransformMakeScale(scaleUpFactor, scaleUpFactor)];
		[self->backgroundView addSubview:self->titleLabel];
		
		[self setClipsToBounds:NO];
	}
	
	return self;
}

- (void)setTitleLabelText:(NSString*)newTitleLabel {
	self->_titleLabelText = newTitleLabel;
	[self->titleLabel setText:newTitleLabel];
}

- (NCMaterialView*)backgroundView {
	return self->backgroundView;
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

@end
