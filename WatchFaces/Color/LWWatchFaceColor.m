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
		self->contentView = [Indicators indicatorsForColor];
		[self addSubview:self->contentView];
		
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
