//
//  Indicators.m
//  LockWatch
//
//  Created by Janik Schmidt on 05.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "Indicators.h"
#import "_UIBackdropView.h"
#define deg2rad(angle) ((angle) / 180.0 * M_PI)

@implementation Indicators

+ (UIView*)indicatorsForSimpleWithDetail:(int)detail {
	UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 390/2 - 312/2, 312, 312)];
	_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:[_UIBackdropViewSettings settingsForStyle:1]];
	[container addSubview:blurView];
	
	[container.layer setCornerRadius:156.0];
	[container setClipsToBounds:YES];
	
	if (detail == 0) {} else if (detail == 1) {
		[container.layer addSublayer:makeIndicators(60, NO)];
	} else if (detail == 2) {
		[container.layer addSublayer:makeIndicators(120, YES)];
		[container.layer addSublayer:makeIndicatorHighlights(12)];
		[container.layer addSublayer:makeIndicatorHourKnobs()];
	}
	
	return container;
}

static CAShapeLayer* makeIndicators(int count, BOOL usesDarkColor) {
	CAShapeLayer* layer = [CAShapeLayer layer];
	
	[layer setStrokeColor:[UIColor colorWithWhite:(usesDarkColor ? 0.35 : 0.48) alpha:1.0].CGColor];
	[layer setLineWidth:2.0];
	
	UIBezierPath* path = [[UIBezierPath alloc] init];
	for (int i=0; i<count; i++) {
		CGFloat angle = i * (2*M_PI) / count;
		CGPoint inner = CGPointMake((((312/2)-11) * sin(angle)) + (312/2), (((312/2)-11) * -cos(angle)) + (312/2));
		CGPoint outer = CGPointMake(((312/2) * sin(angle)) + (312/2), ((312/2) * -cos(angle)) + (312/2));
		
		[path moveToPoint:inner];
		[path addLineToPoint:outer];
	}
	
	[layer setPath:path.CGPath];
	return layer;
}

static CAShapeLayer* makeIndicatorHighlights(int count) {
	CAShapeLayer* layer = [CAShapeLayer layer];
	
	[layer setStrokeColor:[UIColor colorWithWhite:0.58 alpha:1.0].CGColor];
	[layer setLineWidth:2.0];
	
	UIBezierPath* path = [[UIBezierPath alloc] init];
	for (int i=0; i<count; i++) {
		CGFloat angle = i * (2*M_PI) / count;
		CGPoint inner = CGPointMake((((312/2)-11) * sin(angle)) + (312/2), (((312/2)-11) * -cos(angle)) + (312/2));
		CGPoint outer = CGPointMake(((312/2) * sin(angle)) + (312/2), ((312/2) * -cos(angle)) + (312/2));
		
		[path moveToPoint:inner];
		[path addLineToPoint:outer];
	}
	
	[layer setPath:path.CGPath];
	return layer;
}

static CAShapeLayer* makeIndicatorHourKnobs() {
	CAShapeLayer* layer = [CAShapeLayer layer];
	
	[layer setStrokeColor:[UIColor colorWithWhite:0.70 alpha:1.0].CGColor];
	[layer setLineWidth:8.0];
	[layer setLineCap:kCALineCapRound];
	
	UIBezierPath* path = [[UIBezierPath alloc] init];
	for (int i=0; i<12; i++) {
		CGFloat angle = i * (2*M_PI) / 12;
		
		CGFloat innerRadius = 131 - 8 - 23;
		CGFloat outerRadius = 131;
		
		CGPoint inner = CGPointMake((innerRadius * sin(angle)) + (312/2), (innerRadius * -cos(angle)) + (312/2));
		CGPoint outer = CGPointMake((outerRadius * sin(angle)) + (312/2), (outerRadius * -cos(angle)) + (312/2));
		
		[path moveToPoint:inner];
		[path addLineToPoint:outer];
	}
	
	[layer setPath:path.CGPath];
	return layer;
}

@end
