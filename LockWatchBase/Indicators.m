//
//  Indicators.m
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "Indicators.h"
#import "_UIBackdropView.h"

#if TARGET_OS_SIMULATOR
#define RESOURCE_LOCATION @"/opt/simject/FESTIVAL/LockWatch/Resources"
#else
#define RESOURCE_LOCATION @"/var/mobile/Library/FESTIVAL/LockWatch/Resources"
#endif

@implementation Indicators

/* UTILITY */
+ (UIView*)indicatorsForUtilityWithDetail:(int)detail {
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 390/2 - 312/2, 312, 312)];
	_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:[_UIBackdropViewSettings settingsForStyle:1]];
	[container addSubview:blurView];
	
	[blurView.layer setCornerRadius:156.0];
	[blurView setClipsToBounds:YES];
	
	switch (detail) {
		case 0: {
			UIImageView* indicatorBase = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/utility_detail_1", RESOURCE_LOCATION]]];
			
			[indicatorBase setFrame:CGRectMake(0, 0, 312, 312)];
			
			[container addSubview:indicatorBase];
		}; break;
		case 1: {
			UIImageView* indicatorBase = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/utility_detail_1", RESOURCE_LOCATION]]];
			UIImageView* indicatorDetail = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/utility_detail_2_inner", RESOURCE_LOCATION]]];
			
			[indicatorBase setFrame:CGRectMake(0, 0, 312, 312)];
			[indicatorDetail setFrame:CGRectMake(0, 0, 312, 312)];
			
			[container addSubview:indicatorBase];
			[container addSubview:indicatorDetail];
		}; break;
		case 2: {
			UIImageView* indicatorBase = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/utility_detail_1", RESOURCE_LOCATION]]];
			UIImageView* indicatorDetail = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/utility_detail_3_inner", RESOURCE_LOCATION]]];
			
			[indicatorBase setFrame:CGRectMake(0, 0, 312, 312)];
			[indicatorDetail setFrame:CGRectMake(0, 0, 312, 312)];
			
			[container addSubview:indicatorBase];
			[container addSubview:indicatorDetail];
		}; break;
		case 3: {
			UIImageView* indicatorBase = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/utility_detail_4", RESOURCE_LOCATION]]];
			UIImageView* indicatorDetail = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/utility_detail_3_inner", RESOURCE_LOCATION]]];
			
			[indicatorBase setFrame:CGRectMake(0, 0, 312, 312)];
			[indicatorDetail setFrame:CGRectMake(0, 0, 312, 312)];
			
			[container addSubview:indicatorBase];
			[container addSubview:indicatorDetail];
		}; break;
	}
	
	return container;
}

/* SIMPLE */
+ (UIView*)indicatorsForSimpleWithDetail:(int)detail {
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 390/2 - 312/2, 312, 312)];
	_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:[_UIBackdropViewSettings settingsForStyle:1]];
	[container addSubview:blurView];
	
	[blurView.layer setCornerRadius:156.0];
	[blurView setClipsToBounds:YES];
	
	switch (detail) {
		case 1: {
			UIImageView* indicatorBase = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/simple_detail_1", RESOURCE_LOCATION]]];
			
			[indicatorBase setFrame:CGRectMake(0, 0, 312, 312)];
			
			[container addSubview:indicatorBase];
		}; break;
		case 2: {
			UIImageView* indicatorBase = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/simple_detail_2_base", RESOURCE_LOCATION]]];
			
			UIImageView* indicatorInner = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/simple_detail_2_inner", RESOURCE_LOCATION]]];
			
			[indicatorBase setFrame:CGRectMake(0, 0, 312, 312)];
			[indicatorInner setFrame:CGRectMake(0, 0, 312, 312)];
			
			[container addSubview:indicatorBase];
			[container addSubview:indicatorInner];
		}; break;
		case 3: {
			
			UIImageView* indicatorBase = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/simple_detail_2_base", RESOURCE_LOCATION]]];
			
			UIImageView* indicatorInner = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/simple_detail_2_inner", RESOURCE_LOCATION]]];
			
			UIImageView* indicatorOuter = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/simple_detail_3_outer", RESOURCE_LOCATION]]];
			
			[indicatorBase setFrame:CGRectMake(0, 0, 312, 312)];
			[indicatorInner setFrame:CGRectMake(0, 0, 312, 312)];
			[indicatorOuter setFrame:CGRectMake(0, 0, 312, 312)];
			
			[container addSubview:indicatorBase];
			[container addSubview:indicatorInner];
			[container addSubview:indicatorOuter];
		}; break;
		default: break;
	}
	
	return container;
}

/* COLOR */
+ (UIView*)indicatorsForColorWithAccentColor:(UIColor*)accentColor {
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 390/2 - 312/2, 312, 312)];
	_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:[_UIBackdropViewSettings settingsForStyle:1]];
	[container addSubview:blurView];
	
	[blurView.layer setCornerRadius:156.0];
	[blurView setClipsToBounds:YES];
	
	UIImageView* indicatorBase = [[UIImageView alloc] initWithImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/color", RESOURCE_LOCATION]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[indicatorBase setTintColor:accentColor];
	
	[indicatorBase setFrame:CGRectMake(0, 0, 312, 312)];
	
	[container addSubview:indicatorBase];
	
	return container;
}

/* CHRONOGRAPH */
+ (UIView*)indicatorsForChronograph {
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 390/2 - 312/2, 312, 312)];
	
	return container;
}

@end
