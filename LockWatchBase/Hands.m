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
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
	
	UIView* hand = [[UIView alloc] initWithFrame:CGRectMake(0, -152 + 16, 16, 152)];
	
	// Hour hand base
	CAShapeLayer* layer = [CAShapeLayer layer];
	[layer setFillColor:[UIColor whiteColor].CGColor];
	
	UIBezierPath* basePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 152-16, 16, 16)];
	UIBezierPath* connectorPath = [UIBezierPath bezierPathWithRect:CGRectMake(16/2 - 6/2, 152 - 27 - 8, 6, 27)];
	UIBezierPath* mainPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(16/2 - 14/2, 152 - 65 - 27, 14, 65) cornerRadius:7.0];
	
	CGMutablePathRef combinedPath = CGPathCreateMutableCopy(basePath.CGPath);
	CGPathAddPath(combinedPath, nil, connectorPath.CGPath);
	CGPathAddPath(combinedPath, nil, mainPath.CGPath);
	
	layer.path = combinedPath;
	[hand.layer addSublayer:layer];
	[handBase addSubview:hand];
	
	return handBase;
}

+ (UIView*)minuteHandWithChronographStyle:(BOOL)chronoStyle {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
	
	UIView* hand = [[UIView alloc] initWithFrame:CGRectMake(0, -152 + 16, 16, 152)];
	
	// Minute hand base
	CAShapeLayer* layer = [CAShapeLayer layer];
	[layer setFillColor:[UIColor whiteColor].CGColor];
	
	UIBezierPath* basePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 152-16, 16, 16)];
	UIBezierPath* connectorPath = [UIBezierPath bezierPathWithRect:CGRectMake(16/2 - 6/2, 152 - 27 - 8, 6, 27)];
	UIBezierPath* mainPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(16/2 - 14/2, 152 - 125 - 27, 14, 125) cornerRadius:7.0];
	
	CGMutablePathRef combinedPath = CGPathCreateMutableCopy(basePath.CGPath);
	CGPathAddPath(combinedPath, nil, connectorPath.CGPath);
	CGPathAddPath(combinedPath, nil, mainPath.CGPath);
	
	layer.path = combinedPath;
	[hand.layer addSublayer:layer];
	[handBase addSubview:hand];
	
	return handBase;
}

+ (UIView*)secondHandWithAccentColor:(UIColor*)accentColor {
	UIView* handBase = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
	
	UIView* hand = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 180)];
	
	// Second hand base
	CAShapeLayer* layer = [CAShapeLayer layer];
	[layer setFillColor:[UIColor colorWithRed:255.0/255.0 green:149.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor];
	
	UIBezierPath* basePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 12, 12)];
	UIBezierPath* mainPath = [UIBezierPath bezierPathWithRect:CGRectMake(12/2 - 2/2, -180 + 6 + 24, 2, 180)];
	
	CGMutablePathRef combinedPath = CGPathCreateMutableCopy(basePath.CGPath);
	CGPathAddPath(combinedPath, nil, mainPath.CGPath);
	
	layer.path = combinedPath;
	[hand.layer addSublayer:layer];
	
	CAShapeLayer* additionalLayer = [CAShapeLayer layer];
	[additionalLayer setFillColor:[UIColor blackColor].CGColor];
	
	UIBezierPath* axisPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(12/2 - 4/2, 12/2 - 4/2, 4, 4)];
	additionalLayer.path = axisPath.CGPath;
	[hand.layer addSublayer:additionalLayer];
	
	[handBase addSubview:hand];
	
	return handBase;
}

@end
