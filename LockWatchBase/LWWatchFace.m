//
//  LWWatchFace.m
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "LWWatchFace.h"
#import "NCMaterialView.h"
#import "CAKeyframeAnimation+AHEasing.h"
#import "LWCore.h"

#import <objc/runtime.h>

#define scaleUpFactor (312.0/188.0)
#define deg2rad(angle) ((angle) / 180.0 * M_PI)

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

- (void)prepareForInit {
	[self updateTimeWithHour:10.0 minute:9.0 second:30.0 msecond:0.0];
}

- (void)updateTimeWithHour:(CGFloat)Hour minute:(CGFloat)Minute second:(CGFloat)Second msecond:(CGFloat)Msecond {
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	if (self->secondHand) {
		[self->secondHand.layer removeAnimationForKey:@"secRot"];
		[self->secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		
		CABasicAnimation* secondAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		secondAnim.byValue = [NSNumber numberWithFloat: M_PI * 2.0];
		secondAnim.duration = 60;
		secondAnim.cumulative = YES;
		secondAnim.repeatCount = 1;
		[self->secondHand.layer addAnimation:secondAnim forKey:@"secRot"];
	}
	
	if (self->minuteHand) {
		[self->minuteHand.layer removeAnimationForKey:@"minRot"];
		[self->minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		
		CABasicAnimation* minuteAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		minuteAnim.byValue = [NSNumber numberWithFloat: M_PI * 2.0];
		minuteAnim.duration = 60 * 60;
		minuteAnim.cumulative = YES;
		minuteAnim.repeatCount = 1;
		[self->minuteHand.layer addAnimation:minuteAnim forKey:@"minRot"];
	}
	
	if (self->hourHand) {
		[self->hourHand.layer removeAnimationForKey:@"horRot"];
		[self->hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		
		CABasicAnimation* hourAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		hourAnim.byValue = [NSNumber numberWithFloat: M_PI * 2.0];
		hourAnim.duration = 60 * 60 * 12;
		hourAnim.cumulative = YES;
		hourAnim.repeatCount = 1;
		[self->hourHand.layer addAnimation:hourAnim forKey:@"hourRot"];
	}
}

- (void)didStopUpdatingTime {
	if (self->secondHand) {
		[self->secondHand.layer removeAllAnimations];
	}
	if (self->minuteHand) {
		[self->minuteHand.layer removeAllAnimations];
	}
	if (self->hourHand) {
		[self->hourHand.layer removeAllAnimations];
	}

	float Hour = 10.0;
	float Minute = 9.0;
	float Second = 30.0;
	float Msecond = 0.0;
	
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	[UIView animateWithDuration: 0.25 delay: 0 options: UIViewAnimationOptionCurveLinear animations:^{
		if (self->secondHand) {
			[self->secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		}
		if (self->minuteHand) {
			[self->minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		}
		if (self->hourHand) {
			[self->hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		}
	} completion:nil];
}

- (void)didStartUpdatingTime {
	if (self->secondHand) {
		[self->secondHand.layer removeAllAnimations];
	}
	if (self->minuteHand) {
		[self->minuteHand.layer removeAllAnimations];
	}
	if (self->hourHand) {
		[self->hourHand.layer removeAllAnimations];
	}
	
	NSDate* date = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *hourComp = [gregorian components:NSCalendarUnitHour fromDate:date];
	NSDateComponents *minuteComp = [gregorian components:NSCalendarUnitMinute fromDate:date];
	NSDateComponents *secondComp = [gregorian components:NSCalendarUnitSecond fromDate:date];
	NSDateComponents *MsecondComp = [gregorian components:NSCalendarUnitNanosecond fromDate:date];
	
	float Hour = ([hourComp hour] >= 12) ? [hourComp hour] - 12 : [hourComp hour];
	float Minute = [minuteComp minute];
	float Second = [secondComp second];
	float Msecond = roundf([MsecondComp nanosecond]/1000000);
	
	float secondValue = ((Second/60.0) + ((Msecond/1000) / 60));
	float minuteValue = ((Minute/60) + secondValue/60);
	float hourValue = ((Hour/12) + minuteValue/12);
	
	[UIView animateWithDuration: 0.25 delay: 0 options: UIViewAnimationOptionCurveLinear animations:^{
		if (self->secondHand) {
			[self->secondHand setTransform:CGAffineTransformMakeRotation(deg2rad(secondValue*360))];
		}
		if (self->minuteHand) {
			[self->minuteHand setTransform:CGAffineTransformMakeRotation(deg2rad(minuteValue*360))];
		}
		if (self->hourHand) {
			[self->hourHand setTransform:CGAffineTransformMakeRotation(deg2rad(hourValue*360))];
		}
	} completion:^(BOOL finished) {
		[[LWCore sharedInstance] updateTimeForCurrentWatchFace];
	}];
}

@end
