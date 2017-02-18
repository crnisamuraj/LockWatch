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
	
	NSString* filePath = [NSString stringWithFormat:@"%@/hour_hand", RESOURCE_LOCATION];
	UIImageView* hourHandImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:filePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[hourHandImage setFrame:CGRectMake(0, -91 + 15, 15, 91)];
	[hourHandImage setTintColor:accentColor];
	
	[handBase addSubview:hourHandImage];
	
	return handBase;
}

+ (UIView*)minuteHandWithAccentColor:(UIColor*)accentColor andChronographStyle:(BOOL)chronoStyle {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
	
	NSString* filePath = [NSString stringWithFormat:@"%@/minute_hand", RESOURCE_LOCATION];
	UIImageView* minuteHandImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:filePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[minuteHandImage setFrame:CGRectMake(0, -151 + 15, 15, 151)];
	[minuteHandImage setTintColor:accentColor];
	
	[handBase addSubview:minuteHandImage];
	
	return handBase;
}

+ (UIView*)secondHandWithAccentColor:(UIColor*)accentColor {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
	
	NSString* filePath = [NSString stringWithFormat:@"%@/second_hand", RESOURCE_LOCATION];
	UIImageView* secondHandImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:filePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[secondHandImage setFrame:CGRectMake(0, -180 + 29, 10, 180)];
	[secondHandImage setTintColor:accentColor];
	
	[handBase addSubview:secondHandImage];
	
	return handBase;
}

+ (UIView*)chronoSecondHand {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
	
	NSString* filePath = [NSString stringWithFormat:@"%@/chrono_hand", RESOURCE_LOCATION];
	UIImageView* secondHandImage = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:filePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[secondHandImage setFrame:CGRectMake(0, -47 + 6, 6, 47)];
	[secondHandImage setTintColor:[UIColor whiteColor]];
	
	[handBase addSubview:secondHandImage];
	
	return handBase;
}

@end
