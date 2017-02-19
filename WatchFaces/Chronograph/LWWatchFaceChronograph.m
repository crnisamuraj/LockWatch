//
//  LWWatchFaceChronograph.m
//  WatchFaces
//
//  Created by Janik Schmidt on 19.02.17.
//
//

#import "LWWatchFaceChronograph.h"

@implementation LWWatchFaceChronograph

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->contentView = [Indicators indicatorsForChronograph];
		[self addSubview:self->contentView];
		
		self->secondHand = [Hands chronoSecondHandWithAccentColor:[UIColor whiteColor]];
		[self->secondHand.layer setPosition:CGPointMake(312/2, 312/2 + 57)];
		[self->contentView addSubview:self->secondHand];
		
		self->stopwatchMinutes = [Hands chronoSecondHandWithAccentColor:kWatchColorLightOrange];
		[self->stopwatchMinutes.layer setPosition:CGPointMake(312/2, 312/2 - 57)];
		[self->contentView addSubview:self->stopwatchMinutes];
		
		self->hourHand = [Hands hourHandWithAccentColor:[UIColor whiteColor] andChronographStyle:YES];
		[self->hourHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->hourHand];
		
		self->minuteHand = [Hands minuteHandWithAccentColor:[UIColor whiteColor] andChronographStyle:YES];
		[self->minuteHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->minuteHand];
		
		self->stopwatchSeconds = [Hands secondHandWithAccentColor:kWatchColorLightOrange];
		[self->stopwatchSeconds.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->stopwatchSeconds];
	}
	
	return self;
}

@end
