//
//  Hands.m
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "Hands.h"

@implementation Hands

+ (UIView*)hourHandWithChronographStyle:(BOOL)chronoStyle {
	UIView* hourHandBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
	[hourHandBase setBackgroundColor:[UIColor whiteColor]];
	[hourHandBase.layer setCornerRadius:8.0];
	
	UIView* hourHandConnector = [[UIView alloc] initWithFrame:CGRectMake(16/2 - 6/2, -27 + 8, 6, 27)];
	[hourHandConnector setBackgroundColor:[UIColor whiteColor]];
	[hourHandBase addSubview:hourHandConnector];
	
	UIView* hourHandMain = [[UIView alloc] initWithFrame:CGRectMake(16/2 - 14/2, -65 - 11, 14, 65)];
	[hourHandMain setBackgroundColor:[UIColor whiteColor]];
	[hourHandMain.layer setCornerRadius:7.0];
	[hourHandBase addSubview:hourHandMain];
	
	return hourHandBase;
}

+ (UIView*)minuteHandWithChronographStyle:(BOOL)chronoStyle {
	UIView* minuteHandBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
	[minuteHandBase setBackgroundColor:[UIColor whiteColor]];
	[minuteHandBase.layer setCornerRadius:8.0];
	
	UIView* minuteHandConnector = [[UIView alloc] initWithFrame:CGRectMake(16/2 - 6/2, -27 + 8, 6, 27)];
	[minuteHandConnector setBackgroundColor:[UIColor whiteColor]];
	[minuteHandBase addSubview:minuteHandConnector];
	
	UIView* minuteHandMain = [[UIView alloc] initWithFrame:CGRectMake(16/2 - 14/2, -125 - 11, 14, 125)];
	[minuteHandMain setBackgroundColor:[UIColor whiteColor]];
	[minuteHandMain.layer setCornerRadius:7.0];
	[minuteHandBase addSubview:minuteHandMain];
	
	return minuteHandBase;
}

+ (UIView*)secondHandWithAccentColor:(UIColor*)accentColor {
	UIView* secondHandBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
	[secondHandBase setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:149.0/255.0 blue:0.0/255.0 alpha:1.0]];
	[secondHandBase.layer setCornerRadius:6.0];
	
	UIView* secondHandMain = [[UIView alloc] initWithFrame:CGRectMake(12/2 - 2/2, -180 + 6 + 24, 2, 180)];
	[secondHandMain setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:149.0/255.0 blue:0.0/255.0 alpha:1.0]];
	[secondHandBase addSubview:secondHandMain];
	
	UIView* secondHandAxis = [[UIView alloc] initWithFrame:CGRectMake(12/2 - 4/2, 12/2 - 4/2, 4, 4)];
	[secondHandAxis setBackgroundColor:[UIColor blackColor]];
	[secondHandAxis.layer setCornerRadius:2.0];
	[secondHandBase addSubview:secondHandAxis];
	
	return secondHandBase;
}

@end
