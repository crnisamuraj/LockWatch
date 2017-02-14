//
//  LWWatchFaceColor.m
//  LockWatch
//
//  Created by Janik Schmidt on 14.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "LWWatchFaceColor.h"
#import "Indicators.h"
#import "Hands.h"

@implementation LWWatchFaceColor

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->contentView = [Indicators indicatorsForColor];
		[self addSubview:self->contentView];
		
		[self setTitleLabelText:[@"Color" uppercaseString]];
		
		self->hourHand = [Hands hourHandWithChronographStyle:NO];
		[self->hourHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->hourHand];
		
		self->minuteHand = [Hands minuteHandWithChronographStyle:NO];
		[self->minuteHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->minuteHand];
		
		self->secondHand = [Hands secondHandWithAccentColor:nil];
		[self->secondHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->secondHand];
	}
	
	return self;
}

@end
