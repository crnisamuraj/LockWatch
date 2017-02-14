/*!
	@file		LWScrollView.m
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollView.h"
#import "LWCore.h"
#import "LWScrollViewContainer.h"
#import "CAKeyframeAnimation+AHEasing.h"
#import "NCMaterialView.h"
#import "LockWatch.h"

#import <LockWatchBase/LockWatchBase.h>
#import <AudioToolbox/AudioServices.h>

#define scaleDownFactor (188.0/312.0)
#define spacing 75
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
		[self.wrapperView setUserInteractionEnabled:NO];
		
		self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.size.width/2 - (312+spacing)/2, 0, 312+spacing, 390)];
		[self.contentView setClipsToBounds:NO];
		
		self->watchFaceViews = [[NSMutableArray alloc] init];
		

		NSArray* hardcodedWatchFaces = [[NSArray alloc] initWithObjects:
										[LWWatchFaceSimple class], nil];
		for (Class watchface in hardcodedWatchFaces) {
			int i = [hardcodedWatchFaces indexOfObject:watchface];
			
			LWWatchFace* instance = [[watchface alloc] initWithFrame:CGRectMake(312*i + spacing*i + spacing/2, 0, 312, 390)];
			
			[self.contentView addSubview:instance];
			[self->watchFaceViews addObject:instance];
		}
		
		/*for (NSBundle* plugin in [[LWCore sharedInstance] loadedWatchFaces]) {
			int i = [[[LWCore sharedInstance] loadedWatchFaces] indexOfObject:plugin];
			LWWatchFace* watchFaceInstance = [[[plugin principalClass] alloc] initWithFrame:CGRectMake(312*i + spacing*i + spacing/2, 0, 312, 390)];
			
			if ([plugin localizedInfoDictionary]) {
				NSLog(@"[LockWatch] localized name: %@", [[plugin localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"]);
				[watchFaceInstance setTitleLabelText:[[plugin localizedInfoDictionary][@"CFBundleDisplayName"] uppercaseString]];
			} else {
				[watchFaceInstance setTitleLabelText:[[plugin infoDictionary][@"CFBundleDisplayName"] uppercaseString]];
			}
			
			[self.contentView addSubview:watchFaceInstance];
			[self->watchFaceViews addObject:watchFaceInstance];
		}*/
		
		if ([self->watchFaceViews count] > 0) {
			[[LWCore sharedInstance] setCurrentWatchFace:[self->watchFaceViews objectAtIndex:0]];
			[[LWCore sharedInstance] startUpdatingTime];
		}
		
		[self.contentView setContentSize:CGSizeMake(([self->watchFaceViews count]*312)+([self->watchFaceViews count]*spacing), 390)];
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
		
		if (![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
			self->pressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
			[self addGestureRecognizer:self->pressed];
		}
		
		self->customizeButton = [[LWWatchButton alloc] initWithFrame:CGRectMake(frame.size.width/2 - 210/2, frame.size.height - 56 + 75, 210, 56) withTitle:@"Customize"];
		[self->customizeButton addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:customizeButton];
		
		[self resetAlpha];
	}
	
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[self.wrapperView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	
	if (![[LWCore sharedInstance] isInSelection]) {
		
		[self->customizeButton setFrame:CGRectMake(frame.size.width/2 - 210/2, frame.size.height - 56 + 75, 210, 56)];
		//[self.contentView setFrame:CGRectMake(frame.size.width/2 - (312+spacing)/2, 0, 312+spacing, 390)];
	} else {
		[self->customizeButton setTransform:CGAffineTransformIdentity];
		[self->customizeButton setFrame:CGRectMake(frame.size.width/2 - 210/2, frame.size.height - 56, 210, 56)];
	}
}

- (void)test:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occured"
													message:@"Watch faces cannot be customized yet"
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat width = scrollView.frame.size.width / (self->isScaledDown ? scaleDownFactor : 1);
	CGFloat page = (CGFloat)MAX(MIN([self getCurrentPage], [self->watchFaceViews count]-1), 0);
	
	CGFloat pageProgress = (((page) * width) - scrollView.contentOffset.x)/width;
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
	
	scrollDelta = scrollView.contentOffset.x;
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
	CGFloat width = self.contentView.frame.size.width / (self->isScaledDown ? scaleDownFactor : 1);
	CGFloat page = ceilf(self.contentView.contentOffset.x / width);
	
	return (int)page;
}

- (void)tapped:(UITapGestureRecognizer*)sender {
	if (!self->isScaledDown) {
		return;
	}
	
	[[LWCore sharedInstance] setIsInSelection:NO];
}

- (void)pressed:(id)sender {
	if (self->isScaledDown) {
		return;
	}
	
	[self.wrapperView.layer removeAllAnimations];
	for (LWWatchFace* proto in self->watchFaceViews) {
		[proto.layer removeAllAnimations];
		[[proto backgroundView].layer removeAllAnimations];
	}
	
	[[LWCore sharedInstance] setIsInSelection:YES];
	[self->customizeButton setFrame:CGRectMake(self.frame.size.width/2 - 210/2, self.frame.size.height - 56, 210, 56)];
	
	CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
														  function:QuinticEaseOut
														 fromValue:1.0
														   toValue:scaleDownFactor];
	scale.duration = 0.3;
	scale.removedOnCompletion = NO;
	scale.fillMode = kCAFillModeForwards;
	scale.beginTime = CACurrentMediaTime();
	[self.contentView.layer addAnimation:scale forKey:@"scale"];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:QuinticEaseOut
														   fromValue:0.0
															 toValue:1.0];
	opacity.duration = 0.3;
	opacity.removedOnCompletion = NO;
	opacity.fillMode = kCAFillModeForwards;
	opacity.beginTime = CACurrentMediaTime();
	[self->customizeButton.layer addAnimation:opacity forKey:@"opacity"];
	
	CAAnimation* translate = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"
															  function:QuinticEaseOut
															 fromValue:75.0
															   toValue:0.0];
	translate.duration = 0.3;
	translate.removedOnCompletion = NO;
	translate.fillMode = kCAFillModeForwards;
	translate.beginTime = CACurrentMediaTime();
	[self->customizeButton.layer addAnimation:translate forKey:@"translate"];
	
	[self->customizeButton setAlpha:1.0];
	
	for (LWWatchFace* proto in self->watchFaceViews) {
		[proto fadeInWithContent:(proto != [[LWCore sharedInstance] currentWatchFace])];
	}
}

- (void)scaleUp {
	if (!self->isScaledDown) {
		return;
	}
	
	[self->tapped setEnabled:NO];
	if (![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
		[self->pressed setEnabled:YES];
	}
	
	[self.wrapperView.layer removeAllAnimations];
	for (LWWatchFace* proto in self->watchFaceViews) {
		[proto.layer removeAllAnimations];
		[[proto backgroundView].layer removeAllAnimations];
	}
	
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
	
	[self->customizeButton setAlpha:1.0];
	
	for (LWWatchFace* proto in self->watchFaceViews) {
		[proto fadeOutWithContent:(proto != [[LWCore sharedInstance] currentWatchFace])];
	}
	
	[[LWCore sharedInstance] startUpdatingTime];
	[[[LWCore sharedInstance] currentWatchFace] didStartUpdatingTime];
}

- (void)scaleDown {
	if (self->isScaledDown) {
		return;
	}

	AudioServicesPlaySystemSound(1000 + 500 + 20);
	
	self->isScaledDown = YES;
	[[LWCore sharedInstance] stopUpdatingTime];
	
	[self->customizeButton setTransform:CGAffineTransformIdentity];
	[self->customizeButton setFrame:CGRectMake(self.frame.size.width/2 - 210/2, self.frame.size.height - 56, 210, 56)];
	
	[self->tapped setEnabled:YES];
	if (![[UIDevice currentDevice] _supportsForceTouch] || deviceIsiPad) {
		[self->pressed setEnabled:NO];
	}
	
	[self.contentView setScrollEnabled:YES];
	[self->customizeButton setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0)];
	[self.wrapperView setUserInteractionEnabled:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	[self resetAlpha];
	for (LWWatchFace* proto in self->watchFaceViews) {
		[proto.layer removeAllAnimations];
		[[proto backgroundView].layer removeAllAnimations];
	}
	[self.contentView.layer removeAllAnimations];
	[self.contentView setTransform:CGAffineTransformMakeScale(1, 1)];
	
	[self->customizeButton.layer removeAllAnimations];
	[self->customizeButton setTransform:CGAffineTransformIdentity];
	[self->customizeButton setFrame:CGRectMake(self.frame.size.width/2 - 210/2, self.frame.size.height - 56 + 75, 210, 56)];
	
	[[LWCore sharedInstance] setLockscreenTimeoutEnabled:NO];
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
	
	[self.contentView setTransform:CGAffineTransformMakeScale(scale, scale)];
	
	for (LWWatchFace* proto in self->watchFaceViews) {
		if (proto != [[LWCore sharedInstance] currentWatchFace]) {
			[proto setAlpha:normalizedForce/2];
		} else {
			[[proto backgroundView] setAlpha:normalizedForce];
		}
	}
	
	[self->customizeButton setAlpha:normalizedForce];
	[self->customizeButton setTransform:CGAffineTransformIdentity];
	[self->customizeButton setFrame:CGRectMake(self.frame.size.width/2 - 210/2, self.frame.size.height - 56 + 75, 210, 56)];
	[self->customizeButton setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, (-75*normalizedForce))];
	
	[[LWCore sharedInstance] setLockscreenTimeoutEnabled:NO];
	
	if (normalizedForce >= 1.0) {
		[[LWCore sharedInstance] setIsInSelection:YES];
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	[[LWCore sharedInstance] setLockscreenTimeoutEnabled:YES];
	
	[self.contentView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	[self->customizeButton setTransform:CGAffineTransformIdentity];
	[self->customizeButton setFrame:CGRectMake(self.frame.size.width/2 - 210/2, self.frame.size.height - 56 + 75, 210, 56)];
	[self resetAlpha];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
	if (self->isScaledDown) {
		return;
	}
	
	[[LWCore sharedInstance] setLockscreenTimeoutEnabled:YES];
	
	[self.contentView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	[self->customizeButton setTransform:CGAffineTransformIdentity];
	[self->customizeButton setFrame:CGRectMake(self.frame.size.width/2 - 210/2, self.frame.size.height - 56 + 75, 210, 56)];
	[self resetAlpha];
}

@end
