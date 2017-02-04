/*!
	@file		LWScrollView.m
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollView.h"
#import "LWWatchFacePrototype.h"
#import "LWCore.h"

#import <AudioToolbox/AudioServices.h>

#define scaleDownFactor (188.0/312.0)

@implementation LWScrollView

static LWScrollView* sharedInstance;

+ (id)sharedInstance {
	return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		sharedInstance = self;
		int testingCount = 6;
		
		//[self setBackgroundColor:[UIColor magentaColor]];
		
		for (int i=0; i<testingCount; i++) {
			LWWatchFacePrototype* testView = [[LWWatchFacePrototype alloc] initWithFrame:CGRectMake(312*i + 30*i, 0, 312, 390)];
			[self addSubview:testView];
		}
		
		[self setContentSize:CGSizeMake((testingCount*312)+(testingCount*30), 390)];
		[self setPagingEnabled:YES];
		[self setClipsToBounds:YES];
		[self setScrollEnabled:NO];
		
		self->tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self addGestureRecognizer:self->tapped];
		[self->tapped setEnabled:NO];
		
		[self setShowsHorizontalScrollIndicator:NO];
	}
	
	return self;
}

- (void)tapped:(UITapGestureRecognizer*)sender {
	[[LWCore sharedInstance] setIsInSelection:NO];
}

- (void)scaleUp {
	[self->tapped setEnabled:NO];
	self->isScaledDown = NO;
	[self setClipsToBounds:YES];
	[[self superview] setClipsToBounds:YES];
	
	[self setScrollEnabled:NO];
	[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
}

- (void)scaleDown {
	AudioServicesPlaySystemSound(1000 + 500 + 20);
	
	[self->tapped setEnabled:YES];
	self->isScaledDown = YES;
	[self setClipsToBounds:NO];
	[[self superview] setClipsToBounds:NO];
	
	[self setScrollEnabled:YES];
	[self setTransform:CGAffineTransformMakeScale(scaleDownFactor, scaleDownFactor)];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	
	CGFloat maximumPossibleForce = touch.maximumPossibleForce;
	CGFloat force = touch.force;
	CGFloat normalizedForce = force/maximumPossibleForce;
	CGFloat scale = 1.0 - ((1.0 - scaleDownFactor) * normalizedForce);
	
	if (self->isScaledDown || normalizedForce < 0.1) {
		return;
	}

	[self setTransform:CGAffineTransformMakeScale(scale, scale)];
	
	if (normalizedForce >= 1.0) {
		//[self scaleDown];
		[[LWCore sharedInstance] setIsInSelection:YES];
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (self->isScaledDown) {
		return;
	}
	
	[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (self->isScaledDown) {
		return;
	}
	
	[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
}

@end
