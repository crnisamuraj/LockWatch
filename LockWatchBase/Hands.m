//
//  Hands.m
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "Hands.h"

#if TARGET_OS_SIMULATOR
#define RESOURCE_LOCATION @"/opt/simject/FESTIVAL/LockWatch/Resources"
#else
#define RESOURCE_LOCATION @"/var/mobile/Library/FESTIVAL/LockWatch/Resources"
#endif

@implementation Hands

+ (UIView*)hourHandWithAccentColor:(UIColor*)accentColor andChronographStyle:(BOOL)chronoStyle {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
	
	UIImageView* hourHandImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/hour_hand", RESOURCE_LOCATION]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[hourHandImage setFrame:CGRectMake(0, -91 + 15, 15, 91)];
	[hourHandImage setTintColor:accentColor];
	
	[handBase addSubview:hourHandImage];
	
	if (chronoStyle) {
		UIImageView* hourHandInlay = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/hour_hand_inlay", RESOURCE_LOCATION]]];
		[hourHandInlay setFrame:CGRectMake(0, -91 + 15, 15, 91)];
		[handBase addSubview:hourHandInlay];
	}
	
	return handBase;
}

+ (UIView*)minuteHandWithAccentColor:(UIColor*)accentColor andChronographStyle:(BOOL)chronoStyle {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
	
	UIImageView* minuteHandImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/minute_hand", RESOURCE_LOCATION]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[minuteHandImage setFrame:CGRectMake(0, -151 + 15, 15, 151)];
	[minuteHandImage setTintColor:accentColor];
	
	[handBase addSubview:minuteHandImage];
	
	if (chronoStyle) {
		UIImageView* minuteHandInlay = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/minute_hand_inlay", RESOURCE_LOCATION]]];
		[minuteHandInlay setFrame:CGRectMake(0, -151 + 15, 15, 151)];
		[handBase addSubview:minuteHandInlay];
	}
	
	return handBase;
}

+ (UIView*)secondHandWithAccentColor:(UIColor*)accentColor {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
	
	UIImageView* secondHandImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/second_hand", RESOURCE_LOCATION]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[secondHandImage setFrame:CGRectMake(0, -180 + 29, 10, 180)];
	[secondHandImage setTintColor:accentColor];
	
	[handBase addSubview:secondHandImage];
	
	return handBase;
}

+ (UIView*)chronoSecondHandWithAccentColor:(UIColor*)accentColor {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
	
	UIImageView* secondHandImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/chrono_hand", RESOURCE_LOCATION]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[secondHandImage setFrame:CGRectMake(0, -47 + 6, 6, 47)];
	[secondHandImage setTintColor:accentColor];
	
	[handBase addSubview:secondHandImage];
	
	return handBase;
}

@end
