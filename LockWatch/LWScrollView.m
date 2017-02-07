/*!
	@file		LWScrollView.m
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollView.h"
#import "LWCore.h"
#import "LWWatchFacePrototype.h"
#import "LWScrollViewContainer.h"
#import "CAKeyframeAnimation+AHEasing.h"
#import "NCMaterialView.h"

#import <LockWatchBase/WatchButton.h>
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
		
		self.wrapperView = [[LWScrollViewContainer alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self.wrapperView setUserInteractionEnabled:NO];
		
		self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.size.width/2 - (312+spacing)/2, 0, 312+spacing, 390)];
		[self.contentView setClipsToBounds:NO];
		
		self->watchFaceViews = [[NSMutableArray alloc] init];
		
		int testingCount = 3;
		for (int i=0; i<testingCount; i++) {
			LWWatchFacePrototype* prototype = [[LWWatchFacePrototype alloc] initWithFrame:CGRectMake(312*i + spacing*i + spacing/2, 0, 312, 390)];
			[prototype setLevelOfDetail:i];
			[self.contentView addSubview:prototype];
			[self->watchFaceViews addObject:prototype];
		}
		
		[[LWCore sharedInstance] setCurrentWatchFace:[self->watchFaceViews objectAtIndex:0]];
		
		[self.contentView setContentSize:CGSizeMake((testingCount*312)+(testingCount*spacing), 390)];
		[self.contentView setPagingEnabled:YES];
		[self.contentView setScrollEnabled:NO];
		[self.contentView setClipsToBounds:NO];
		[self.contentView setDelegate:self];
		[self.contentView setShowsHorizontalScrollIndicator:NO];
		
		[self.wrapperView addSubview:self.contentView];
		[self addSubview:self.wrapperView];
		
		self->tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self.wrapperView addGestureRecognizer:self->tapped];
		[self->tapped setEnabled:NO];
		
		self->customizeButton = [[WatchButton alloc] initWithFrame:CGRectMake(frame.size.width/2 - 210/2, frame.size.height - 56, 210, 56) withTitle:@"Customize"];
		[self->customizeButton addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:customizeButton];
		
		[self resetAlpha];
	}
	
	return self;
}

- (void)test:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occured"
													message:@"Watch faces cannot be customized yet"
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

- (void)resetAlpha {
	for (LWWatchFacePrototype* proto in self->watchFaceViews) {
		if (proto != [[LWCore sharedInstance] currentWatchFace]) {
			[proto setAlpha:0.0];
		} else {
			[[proto backgroundView] setAlpha:0.0];
		}
	}
	
	[self->customizeButton setAlpha:0.0];
}

- (int)getCurrentPage {
	CGFloat width = self.contentView.frame.size.width / (self->isScaledDown ? scaleDownFactor : 1);
	CGFloat page = ceilf(self.contentView.contentOffset.x / width);
	
	return (int)page;
}

- (void)tapped:(UITapGestureRecognizer*)sender {
	[[LWCore sharedInstance] setIsInSelection:NO];
}

- (void)scaleUp {
	if (!self->isScaledDown) {
		return;
	}
	
	[self->tapped setEnabled:NO];
	[[LWCore sharedInstance] setCurrentWatchFace:[self->watchFaceViews objectAtIndex:[self getCurrentPage]]];
	
	self->isScaledDown = NO;
	[self.contentView setScrollEnabled:NO];
	[self.wrapperView setUserInteractionEnabled:NO];
	
	CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
														  function:QuinticEaseOut
														 fromValue:scaleDownFactor
														   toValue:1.0];
	scale.duration = 0.3;
	scale.removedOnCompletion = NO;
	scale.fillMode = kCAFillModeForwards;
	scale.beginTime = CACurrentMediaTime();
	[self.contentView.layer addAnimation:scale forKey:@"scale"];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:1.0
															 toValue:0.0];
	opacity.duration = 0.3;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	opacity.beginTime = CACurrentMediaTime();
	[self->customizeButton.layer addAnimation:opacity forKey:@"opacity"];
	
	CAAnimation* translate = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"
															function:QuinticEaseOut
														   fromValue:0.0
															 toValue:75.0];
	translate.duration = 0.3;
	translate.removedOnCompletion = NO;
	translate.fillMode = kCAFillModeForwards;
	translate.beginTime = CACurrentMediaTime();
	[self->customizeButton.layer addAnimation:translate forKey:@"translate"];
	
	
	for (LWWatchFacePrototype* proto in self->watchFaceViews) {
		[proto fadeOutWithContent:(proto != [[LWCore sharedInstance] currentWatchFace])];
	}
}

- (void)scaleDown {
	if (self->isScaledDown) {
		return;
	}
	
	AudioServicesPlaySystemSound(1000 + 500 + 20);
	
	self->isScaledDown = YES;
	
	[self->tapped setEnabled:YES];
	[self.contentView setScrollEnabled:YES];
	[self.contentView setTransform:CGAffineTransformMakeScale(scaleDownFactor, scaleDownFactor)];
	[self->customizeButton setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0)];
	[self.wrapperView setUserInteractionEnabled:YES];
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
	[self.contentView.layer removeAllAnimations];
	[self->customizeButton.layer removeAllAnimations];
	[self->customizeButton setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 75)];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	UITouch *touch = [touches anyObject];
	
	CGFloat maximumPossibleForce = touch.maximumPossibleForce;
	CGFloat force = touch.force;
	CGFloat normalizedForce = MIN(MAX((force/maximumPossibleForce)-0.25, 0.0) / 0.4, 1.0);
	
	CGFloat scale = 1.0 - ((1.0 - scaleDownFactor) * normalizedForce);
	
	[self.contentView setTransform:CGAffineTransformMakeScale(scale, scale)];
	
	for (LWWatchFacePrototype* proto in self->watchFaceViews) {
		if (proto != [[LWCore sharedInstance] currentWatchFace]) {
			[proto setAlpha:normalizedForce];
		} else {
			[[proto backgroundView] setAlpha:normalizedForce];
		}
	}
	
	[self->customizeButton setAlpha:normalizedForce];
	[self->customizeButton setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 75 - (75*normalizedForce))];
	
	if (normalizedForce >= 1.0) {
		[[LWCore sharedInstance] setIsInSelection:YES];
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	[self.contentView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	[self->customizeButton setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 75)];
	[self resetAlpha];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	[self.contentView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	[self->customizeButton setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 75)];
	[self resetAlpha];
}

@end
