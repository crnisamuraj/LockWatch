/*!
	@file		LWScrollView.m
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollView.h"
#import "LWWatchFacePrototype.h"
#define scaleDownFactor (188.0/312.0)

@implementation LWScrollView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		int testingCount = 6;
		
		[self setBackgroundColor:[UIColor magentaColor]];
		
		for (int i=0; i<testingCount; i++) {
			LWWatchFacePrototype* testView = [[LWWatchFacePrototype alloc] initWithFrame:CGRectMake(312*i + 30*i, 0, 312, 390)];
			[self addSubview:testView];
		}
		
		[self setContentSize:CGSizeMake((testingCount*312)+(testingCount*30), 390)];
		[self setPagingEnabled:YES];
		[self setClipsToBounds:YES];
		[self setScrollEnabled:NO];
		
		self->tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleUp:)];
		[self addGestureRecognizer:self->tapped];
		[self->tapped setEnabled:NO];
	}
	
	return self;
}

- (void)scaleUp:(UITapGestureRecognizer*)sender {
	[self->tapped setEnabled:NO];
	self->isScaledDown = NO;
	[self setClipsToBounds:YES];
	[self setScrollEnabled:NO];
	[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
}

- (void)scaleDown {
	[self->tapped setEnabled:YES];
	self->isScaledDown = YES;
	[self setClipsToBounds:NO];
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
	
	if (normalizedForce > 0.9) {
		[self scaleDown];
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (self->isScaledDown) {
		return;
	}
	
	[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
}

@end
