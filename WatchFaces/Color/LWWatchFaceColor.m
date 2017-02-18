//
//  LWWatchFaceColor.m
//  WatchFaces
//
//  Created by Janik Schmidt on 18.02.17.
//
//

#import "LWWatchFaceColor.h"

@implementation LWWatchFaceColor

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->contentView = [Indicators indicatorsForColorWithAccentColor:kWatchColorBlue];
		[self addSubview:self->contentView];
		
		self->hourHand = [Hands hourHandWithAccentColor:[UIColor whiteColor] andChronographStyle:NO];
		[self->hourHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->hourHand];
		
		self->minuteHand = [Hands minuteHandWithAccentColor:[UIColor whiteColor] andChronographStyle:NO];
		[self->minuteHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->minuteHand];
		
		self->secondHand = [Hands secondHandWithAccentColor:kWatchColorLightOrange];
		[self->secondHand.layer setPosition:CGPointMake(312/2, 312/2)];
		[self->contentView addSubview:self->secondHand];
	}
	
	return self;
}

@end
