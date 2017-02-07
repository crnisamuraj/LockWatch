/*!
	@file		LWCore.m
	@abstract	The core of LockWatch, managing everything from Timers to Plugins
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWCore.h"
#import "LockWatch.h"
#import "LWScrollViewContainer.h"
#import "LWInterfaceView.h"
#import "LWScrollView.h"
#import <objc/runtime.h>

@implementation LWCore

static LWCore* sharedInstance;

+ (id)sharedInstance {
	return sharedInstance;
}

- (id)init {
	self = [super init];
	
	if (self) {
		sharedInstance = self;
		
		float screenW = [[UIScreen mainScreen] bounds].size.width;
		float screenH = [[UIScreen mainScreen] bounds].size.height;
		self.interfaceView = [[LWInterfaceView alloc] initWithFrame:CGRectMake(0, screenH/2 - 390/2, screenW, 390)];
	}

	return self;
}

- (void)startUpdatingTime {
	self->timeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeForCurrentWatchFace) userInfo:nil repeats:YES];
	self->isUpdatingTime = YES;
}
- (void)stopUpdatingTime {
	[self->timeUpdateTimer invalidate];
	self->isUpdatingTime = NO;
}
- (BOOL)isUpdatingTime {
	return self->isUpdatingTime;
}
- (void)updateTimeForCurrentWatchFace {
	NSLog(@"[LockWatch] Updating time");
	if (self->currentWatchFace) {
		
	}
}

- (void)setCurrentWatchFace:(id)watchFace {
	self->currentWatchFace = watchFace;
}
- (id)currentWatchFace {
	if (self->isInSelection) {
		return nil;
	}
	
	return self->currentWatchFace;
}

- (void)setIsInSelection:(BOOL)selection {
	self->isInSelection = selection;
	[[[[[objc_getClass("SBLockScreenManager") sharedInstance] lockScreenViewController] scrollGestureController] scrollView] setScrollEnabled:!selection];
	[[objc_getClass("SBBacklightController") sharedInstance] resetLockScreenIdleTimer];
	[[objc_getClass("SBBacklightController") sharedInstance] _resetLockScreenIdleTimerWithDuration:(selection?-1:self.defaultDimInterval) mode:1];
	
	if (selection) {
		[[LWScrollView sharedInstance] scaleDown];
	} else {
		[[objc_getClass("SBBacklightController") sharedInstance] resetLockScreenIdleTimer];
		[[LWScrollView sharedInstance] scaleUp];
	}
}
- (BOOL)isInSelection {
	return self->isInSelection;
}

- (void)setFrameForMinimizedView:(CGRect)frame {
	self->minimizedFrame = frame;
}

- (void)setIsInMinimizedView:(BOOL)isMinimized {
	if (isMinimized == self->isInMinimizedView) {
		return;
	}
	
	self->isInMinimizedView = isMinimized;
	[self.interfaceView setUserInteractionEnabled:!isMinimized];
	
	float screenW = [[UIScreen mainScreen] bounds].size.width;
	float screenH = [[UIScreen mainScreen] bounds].size.height;
	
	if (self->isInSelection) {
		[self setIsInSelection:NO];
	}
	
	if (isMinimized) {
		CGRect labelFrame = self->minimizedFrame;
		CGRect oldFrame = CGRectMake(0, screenH/2 - 390/2, screenW, 390);
		CGFloat scale = labelFrame.size.height / 312.0;
		
		CGRect newFrame = CGRectMake(((labelFrame.size.width/2) - ((oldFrame.size.width*scale)/2)) + labelFrame.origin.x,
									 ((labelFrame.size.height/2) - ((oldFrame.size.height*scale)/2)) + labelFrame.origin.y,
									 oldFrame.size.width*scale,
									 oldFrame.size.height*scale);
		
		[UIView animateWithDuration:0.2 animations:^{
			self.interfaceView.transform = CGAffineTransformMakeScale(scale, scale);
			self.interfaceView.frame = newFrame;
		}];
	} else {
		[UIView animateWithDuration:0.2 animations:^{
			self.interfaceView.transform = CGAffineTransformMakeScale(1, 1);
			self.interfaceView.frame = CGRectMake(0, screenH/2 - 390/2, screenW, 390);
		}];
	}
}

@end
