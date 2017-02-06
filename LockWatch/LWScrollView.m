/*!
	@file		LWScrollView.m
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollView.h"
#import "LWWatchFacePrototype.h"
#import "LWCore.h"
#import "CAKeyframeAnimation+AHEasing.h"
#import "NCMaterialView.h"

#import <AudioToolbox/AudioServices.h>

#define scaleDownFactor (188.0/312.0)
#define spacing 75

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
		
		self->watchFaceViews = [[NSMutableArray alloc] init];
		
		for (int i=0; i<testingCount; i++) {
			LWWatchFacePrototype* testView = [[LWWatchFacePrototype alloc] initWithFrame:CGRectMake(312*i + spacing*i + spacing/2, 0, 312, 390)];
			[self addSubview:testView];
			[self->watchFaceViews addObject:testView];
		}
		
		[[LWCore sharedInstance] setCurrentWatchFace:[self->watchFaceViews objectAtIndex:0]];
		[self resetAlpha];
		
		[self setContentSize:CGSizeMake((testingCount*312)+(testingCount*spacing), 390)];
		[self setPagingEnabled:YES];
		[self setScrollEnabled:NO];
		[self setClipsToBounds:NO];
		
		self->tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self addGestureRecognizer:self->tapped];
		[self->tapped setEnabled:NO];
		
		[self setShowsHorizontalScrollIndicator:NO];
	}
	
	return self;
}

- (void)scaleUp {
	if (!self->isScaledDown) {
		return;
	}
	
	[[LWCore sharedInstance] setCurrentWatchFace:[self->watchFaceViews objectAtIndex:[self getCurrentPage]]];
	
	[self->tapped setEnabled:NO];
	self->isScaledDown = NO;
	
	[self setScrollEnabled:NO];
	
	CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
														  function:QuinticEaseOut
														 fromValue:scaleDownFactor
														   toValue:1.0];
	scale.duration = 0.3;
	scale.removedOnCompletion = NO;
	scale.fillMode = kCAFillModeForwards;
	scale.beginTime = CACurrentMediaTime();
	[self.layer addAnimation:scale forKey:@"scale"];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
														  function:QuinticEaseOut
														 fromValue:1.0
														   toValue:0.0];
	opacity.duration = 0.3;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	opacity.beginTime = CACurrentMediaTime();
	[self.customizeButton.layer addAnimation:opacity forKey:@"opacity"];
	
	for (LWWatchFacePrototype* proto in self->watchFaceViews) {
		[proto fadeOutWithContent:(proto != [[LWCore sharedInstance] currentWatchFace])];
	}
}

- (void)scaleDown {
	if (self->isScaledDown) {
		return;
	}
	
	AudioServicesPlaySystemSound(1000 + 500 + 20);
	
	[self->tapped setEnabled:YES];
	self->isScaledDown = YES;
	[[self superview] setClipsToBounds:NO];
	
	[self setScrollEnabled:YES];
	[self setTransform:CGAffineTransformMakeScale(scaleDownFactor, scaleDownFactor)];
}

- (NSArray*)watchFaceViews {
	return self->watchFaceViews;
}

- (void)tapped:(UITapGestureRecognizer*)sender {
	[[LWCore sharedInstance] setIsInSelection:NO];
}

- (int)getCurrentPage {
	CGFloat width = self.frame.size.width / (self->isScaledDown ? scaleDownFactor : 1);
	CGFloat page = ceilf(self.contentOffset.x / width);
	
	return (int)page;
}

- (void)resetAlpha {
	for (LWWatchFacePrototype* proto in self->watchFaceViews) {
		if (proto != [[LWCore sharedInstance] currentWatchFace]) {
			[proto setAlpha:0.0];
		} else {
			[[proto backgroundView] setAlpha:0.0];
		}
	}
	
	if (self.customizeButton) {
		[self.customizeButton setAlpha:0];
	}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	[self resetAlpha];
	for (LWWatchFacePrototype* proto in self->watchFaceViews) {
		[proto.layer removeAllAnimations];
		[[proto backgroundView].layer removeAllAnimations];
	}
	[self.customizeButton.layer removeAllAnimations];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	
	CGFloat maximumPossibleForce = touch.maximumPossibleForce;
	CGFloat force = touch.force;
	CGFloat normalizedForce = MIN(MAX((force/maximumPossibleForce)-0.25, 0.0) / 0.4, 1.0);
	
	CGFloat scale = 1.0 - ((1.0 - scaleDownFactor) * normalizedForce);
	
	if (self->isScaledDown) {
		return;
	}

	[self.layer removeAllAnimations];
	[self setTransform:CGAffineTransformMakeScale(scale, scale)];
	for (LWWatchFacePrototype* proto in self->watchFaceViews) {
		if (proto != [[LWCore sharedInstance] currentWatchFace]) {
			[proto setAlpha:normalizedForce];
		} else {
			[[proto backgroundView] setAlpha:normalizedForce];
		}
	}
	
	[self.customizeButton setAlpha:normalizedForce];
	
	if (normalizedForce >= 1.0) {
		[[LWCore sharedInstance] setIsInSelection:YES];
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	[self resetAlpha];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	[self resetAlpha];
}

- (void)setCustomizeButton:(UIButton *)customizeButton {
	_customizeButton = customizeButton;
	self.customizeButton.alpha = 0;
}

@end
