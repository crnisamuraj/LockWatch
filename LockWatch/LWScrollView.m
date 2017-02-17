/*!
	@file		LWScrollView.m
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollView.h"
#import "LWScrollViewContainer.h"
#import "LWCore.h"
#import "NCMaterialView.h"
#import "CAKeyframeAnimation+AHEasing.h"

#import <LockWatchBase/LockWatchBase.h>
#import <AudioToolbox/AudioServices.h>

#define spacing 75
#define scaleDownFactor (188.0/312.0)
#define deviceIsiPad ([[UIScreen mainScreen] bounds].size.width >= 768)

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
		self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.size.width/2 - (312+spacing)/2, 0, 312+spacing, 390)];
		self->customizeButton = [[LWWatchButton alloc] initWithFrame:CGRectMake(frame.size.width/2 - 210/2, frame.size.height - 56 + 56, 210, 56) withTitle:@"Customize"];
		
		[self.wrapperView setUserInteractionEnabled:NO];
		
		[self.contentView setPagingEnabled:YES];
		[self.contentView setScrollEnabled:NO];
		[self.contentView setClipsToBounds:NO];
		[self.contentView setDelegate:self];
		[self.contentView setShowsHorizontalScrollIndicator:NO];
		
		[self->customizeButton setAlpha:0.0];
		
		[self.wrapperView addSubview:self.contentView];
		[self addSubview:self.wrapperView];
		[self addSubview:self->customizeButton];
		
		// I hate constraints. More than code signing.
		[self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
														 attribute:NSLayoutAttributeCenterX
														 relatedBy:NSLayoutRelationEqual
															toItem:self.wrapperView
														 attribute:NSLayoutAttributeCenterX
														multiplier:1.f constant:0.f]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
														 attribute:NSLayoutAttributeCenterY
														 relatedBy:NSLayoutRelationEqual
															toItem:self.wrapperView
														 attribute:NSLayoutAttributeCenterY
														multiplier:1.f constant:0.f]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
														 attribute:NSLayoutAttributeWidth
														 relatedBy:NSLayoutRelationEqual
															toItem:nil
														 attribute:NSLayoutAttributeNotAnAttribute
														multiplier:1.0
														  constant:312+spacing]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:nil
														 attribute:NSLayoutAttributeNotAnAttribute
														multiplier:1.0
														  constant:390]];
		
		self->watchFaceViews = [[NSMutableArray alloc] init];
		for (NSBundle* plugin in [[LWCore sharedInstance] loadedWatchFaces]) {
			int i = [[[LWCore sharedInstance] loadedWatchFaces] indexOfObject:plugin];
			LWWatchFace* instance = [[[plugin principalClass] alloc] initWithFrame:CGRectMake(312*i + spacing*i + spacing/2, 0, 312, 390)];
			
			if ([plugin localizedInfoDictionary]) {
				[instance setTitleLabelText:[[plugin localizedInfoDictionary][@"CFBundleDisplayName"] uppercaseString]];
			} else {
				[instance setTitleLabelText:[[plugin infoDictionary][@"CFBundleDisplayName"] uppercaseString]];
			}
			
			[instance prepareForInit];
			
			[self.contentView addSubview:instance];
			[self->watchFaceViews addObject:instance];
		}
		
		if ([self->watchFaceViews count] > 0) {
			[self.contentView setContentSize:CGSizeMake(([self->watchFaceViews count]*312)+([self->watchFaceViews count]*spacing), 390)];
			[[LWCore sharedInstance] setCurrentWatchFace:[self->watchFaceViews objectAtIndex:0]];
			[[LWCore sharedInstance] startUpdatingTime];
		}
		
		self->tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self.wrapperView addGestureRecognizer:self->tapped];
		[self->tapped setEnabled:NO];
		
		if (deviceIsiPad) {
			self->pressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
			[self addGestureRecognizer:self->pressed];
		}
		
		[self resetAlpha];
	}
	
	return self;
}

- (void)test:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LockWatch"
													message:@"Watch faces cannot be customized yet"
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[self.wrapperView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	
	[self->customizeButton setFrame:CGRectMake(frame.size.width/2 - 210/2,
											   frame.size.height - 56 + (self->isScaledDown ?: 56),
											   210,
											   56)];
}

- (void)resetAlpha {
	for (LWWatchFace* proto in self->watchFaceViews) {
		if (proto != [[LWCore sharedInstance] currentWatchFace]) {
			[proto setAlpha:0.0];
		} else {
			[[proto backgroundView] setAlpha:0.0];
		}
	}
	
	[self->customizeButton setAlpha:0.0];
}

- (int)getCurrentPage {
	CGFloat width = (self.contentView.frame.size.width < (312+spacing) ? self.contentView.frame.size.width / (self->isScaledDown ? scaleDownFactor : 1) : self.contentView.frame.size.width);
	CGFloat page = ceilf(self.contentView.contentOffset.x / width);
	
	return (int)MAX(MIN(page, [self->watchFaceViews count]-1), 0);
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
	CGFloat width = (self.contentView.frame.size.width < (312+spacing) ? self.contentView.frame.size.width / (self->isScaledDown ? scaleDownFactor : 1) : self.contentView.frame.size.width);
	CGFloat offset = scrollView.contentOffset.x;
	CGFloat page = (CGFloat)[self getCurrentPage];
	
	CGFloat pageProgress = (((page) * width) - offset)/width;
	pageProgress = (round(pageProgress*100))/100.0;
	
	int prevIndex = (page > 0) ? floor(page) : 0;
	int nextIndex = (page < [self->watchFaceViews count]-1) ? ceil(page) : (int)[self->watchFaceViews count]-1;
	
	if (self->scrollDelta != scrollView.contentOffset.x) {
		LWWatchFace* next = [self->watchFaceViews objectAtIndex:nextIndex];
		
		if (self->scrollDelta < scrollView.contentOffset.x) {
			if (scrollView.contentOffset.x+width <= scrollView.contentSize.width && scrollView.contentOffset.x > 0) {
				LWWatchFace* current = [self->watchFaceViews objectAtIndex:MAX(nextIndex-1, 0)];
				
				[[current layer] removeAllAnimations];
				[[current.backgroundView layer] removeAllAnimations];
				[[next layer] removeAllAnimations];
				[[next.backgroundView layer] removeAllAnimations];
				
				[current setAlpha:MAX(0.5, pageProgress)];
				[next setAlpha:MAX(0.5, 1-pageProgress)];
			} else if (scrollView.contentOffset.x <= 0) {
				LWWatchFace* current = [self->watchFaceViews objectAtIndex:page];
				
				[self->customizeButton.layer removeAllAnimations];
				self->customizeButton.alpha = 1+(scrollView.contentOffset.x/width);
				
				[[current layer] removeAllAnimations];
				[current setAlpha:MAX(0.5, 1+(scrollView.contentOffset.x/width))];
			} else {
				LWWatchFace* current = [self->watchFaceViews objectAtIndex:page];
				
				[self->customizeButton.layer removeAllAnimations];
				self->customizeButton.alpha = 1-((scrollView.contentOffset.x+width)-scrollView.contentSize.width)/width;
				
				[[current layer] removeAllAnimations];
				[current setAlpha:MAX(0.5, 1-((scrollView.contentOffset.x+width)-scrollView.contentSize.width)/width)];
			}
		}
		
		if (self->scrollDelta > scrollView.contentOffset.x) {
			LWWatchFace* prev = [self->watchFaceViews objectAtIndex:prevIndex];
			if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x+width <= scrollView.contentSize.width) {
				LWWatchFace* current = [self->watchFaceViews objectAtIndex:MIN(prevIndex-1, [self->watchFaceViews count]-1)];
				
				[[current layer] removeAllAnimations];
				[[current.backgroundView layer] removeAllAnimations];
				[[prev layer] removeAllAnimations];
				[[prev.backgroundView layer] removeAllAnimations];
				
				[current setAlpha:MAX(0.5, pageProgress)];
				[prev setAlpha:MAX(0.5, 1-pageProgress)];
			} else if (scrollView.contentOffset.x+width > scrollView.contentSize.width) {
				LWWatchFace* current = [self->watchFaceViews objectAtIndex:page];
				
				[self->customizeButton.layer removeAllAnimations];
				self->customizeButton.alpha = 1-((scrollView.contentOffset.x+width)-scrollView.contentSize.width)/width;
				
				[[current layer] removeAllAnimations];
				[current setAlpha:MAX(0.5, 1-((scrollView.contentOffset.x+width)-scrollView.contentSize.width)/width)];
			} else {
				LWWatchFace* current = [self->watchFaceViews objectAtIndex:page];
				
				[self->customizeButton.layer removeAllAnimations];
				self->customizeButton.alpha = 1+(scrollView.contentOffset.x/width);
				
				[[current layer] removeAllAnimations];
				[current setAlpha:MAX(0.5, 1+(scrollView.contentOffset.x/width))];
			}
		}
	}
	
	self->scrollDelta = scrollView.contentOffset.x;
}

- (void)animateScaleToFactor:(float)endValue fromFactor:(float)beginningValue duration:(double)duration {
	[self.contentView.layer removeAllAnimations];
	[self->customizeButton.layer removeAllAnimations];
	
	CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
														  function:QuinticEaseOut
														 fromValue:beginningValue
														   toValue:endValue];
	scale.duration = duration;
	scale.removedOnCompletion = NO;
	scale.fillMode = kCAFillModeForwards;
	scale.beginTime = CACurrentMediaTime();
	
	[self.contentView.layer addAnimation:scale forKey:@"scale"];
	
	self->currentScale = endValue;
}
- (void)animateCustomizeButtonToPosition:(double)newYPos fromPosition:(double)oldYPos withAlpha:(float)alpha duration:(float)duration {
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:[self->customizeButton alpha]
															 toValue:alpha];
	opacity.duration = duration;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	opacity.beginTime = CACurrentMediaTime();
	
	
	CAAnimation* translate = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"
															  function:QuinticEaseOut
															 fromValue:oldYPos
															   toValue:newYPos];
	translate.duration = duration;
	translate.removedOnCompletion = NO;
	translate.fillMode = kCAFillModeForwards;
	translate.beginTime = CACurrentMediaTime();
	
	[self->customizeButton.layer addAnimation:opacity forKey:@"opacity"];
	[self->customizeButton.layer addAnimation:translate forKey:@"translate"];
	
	//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self->customizeButton setAlpha:alpha];
		[self->customizeButton setFrame:CGRectMake(self.frame.size.width/2 - 210/2, self.frame.size.height - 56 + newYPos, 210, 56)];
	//});
}

- (void)tapped:(id)sender {
	if (!self->isScaledDown) {
		return;
	}
	
	[[LWCore sharedInstance] setIsInSelection:NO];
}
- (void)pressed:(id)sender {
	[self->pressed setEnabled:NO];
	
	[[LWCore sharedInstance] setIsInSelection:YES];
	
	for (LWWatchFace* watchface in self->watchFaceViews) {
		[watchface fadeInWithContent:(watchface != [[LWCore sharedInstance] currentWatchFace])];
	}
	
	[self animateScaleToFactor:scaleDownFactor fromFactor:1.0 duration:0.25];
	[self animateCustomizeButtonToPosition:0 fromPosition:56 withAlpha:1.0 duration:0.25];
}

- (void)scaleUp {
	if (!self->isScaledDown) {
		return;
	}
	
	self->isScaledDown = NO;
	[self.contentView setScrollEnabled:NO];
	[self.wrapperView setUserInteractionEnabled:NO];
	
	[[LWCore sharedInstance] setCurrentWatchFace:[self->watchFaceViews objectAtIndex:[self getCurrentPage]]];
	
	[self->tapped setEnabled:NO];
	if (![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
		[self->pressed setEnabled:YES];
	}
	
	[self animateScaleToFactor:1.0 fromFactor:scaleDownFactor duration:0.25];
	[self animateCustomizeButtonToPosition:0 fromPosition:-56 withAlpha:0.0 duration:0.25];
	
	for (LWWatchFace* watchface in self->watchFaceViews) {
		[watchface fadeOutWithContent:(watchface != [[LWCore sharedInstance] currentWatchFace])];
	}
	
	[[LWCore sharedInstance] startUpdatingTime];
	[[[LWCore sharedInstance] currentWatchFace] didStartUpdatingTime];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[[LWCore sharedInstance] updateTimeForCurrentWatchFace];
		[self resetAlpha];
	});


}
- (void)scaleDown {
	if (self->isScaledDown) {
		return;
	}
	
	self->isScaledDown = YES;
	AudioServicesPlaySystemSound(1520);
	[[LWCore sharedInstance] stopUpdatingTime];
	
	[self.contentView setScrollEnabled:YES];
	[self.wrapperView setUserInteractionEnabled:YES];
	
	[self->tapped setEnabled:YES];
	if (![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
		[self->pressed setEnabled:NO];
	}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	if (self->isScaledDown || ![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
		return;
	}
	
	for (LWWatchFace* watchface in self->watchFaceViews) {
		[watchface.layer removeAllAnimations];
		[[watchface backgroundView].layer removeAllAnimations];
	}
	[self.contentView.layer removeAllAnimations];
	[self->customizeButton.layer removeAllAnimations];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	if (self->isScaledDown || ![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
		return;
	}
	
	UITouch *touch = [touches anyObject];
	
	CGFloat maximumPossibleForce = touch.maximumPossibleForce;
	CGFloat force = touch.force;
	CGFloat normalizedForce = MIN(MAX((force/maximumPossibleForce)-0.25, 0.0) / 0.4, 1.0);
	
	CGFloat scale = 1.0 - ((1.0 - scaleDownFactor) * normalizedForce);
	self->currentScale = scale;
	
	[self.contentView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, scale, scale)];
	[self->customizeButton setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, (-56*normalizedForce))];
	[self->customizeButton setAlpha:normalizedForce];
	
	for (LWWatchFace* watchface in self->watchFaceViews) {
		if (watchface != [[LWCore sharedInstance] currentWatchFace]) {
			[watchface setAlpha:normalizedForce/2];
		} else {
			[[watchface backgroundView] setAlpha:normalizedForce];
		}
	}
	
	if (normalizedForce >= 1.0) {
		[[LWCore sharedInstance] setIsInSelection:YES];
	}
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	if (self->isScaledDown || ![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
		return;
	}
	
	[[LWCore sharedInstance] setLockscreenTimeoutEnabled:YES];
	
	[self animateScaleToFactor:1.0 fromFactor:self->currentScale duration:0.25];
	
	[self resetAlpha];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
	if (self->isScaledDown || ![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
		return;
	}
	
	[[LWCore sharedInstance] setLockscreenTimeoutEnabled:YES];
	
	[self animateScaleToFactor:1.0 fromFactor:self->currentScale duration:0.25];
	
	[self resetAlpha];
}

@end
