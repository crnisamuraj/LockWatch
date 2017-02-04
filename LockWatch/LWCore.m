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
		[self.interfaceView setBackgroundColor:[UIColor greenColor]];
		
		self->mainScrollView = [[LWScrollViewContainer alloc] initWithFrame:CGRectMake(screenW/2 - 312/2, 0, 312, 390)];
		[self.interfaceView addSubview:self->mainScrollView];
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
	[[objc_getClass("SBBacklightController") sharedInstance] resetLockScreenIdleTimer];
	[[objc_getClass("SBBacklightController") sharedInstance] _resetLockScreenIdleTimerWithDuration:(selection?-1:self.defaultDimInterval) mode:1];
	//[[objc_getClass("SBBacklightController") sharedInstance] resetLockScreenIdleTimer];
	
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

@end
