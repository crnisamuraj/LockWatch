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

#import <LockWatchBase/LockWatchBase.h>

@implementation LWCore

static LWCore* sharedInstance;

+ (id)sharedInstance {
	return sharedInstance;
}

- (id)init {
	self = [super init];
	
	if (self) {
		sharedInstance = self;
		
		[self loadPlugins];
		
		float screenW = [[UIScreen mainScreen] bounds].size.width;
		float screenH = [[UIScreen mainScreen] bounds].size.height;
		self.interfaceView = [[LWInterfaceView alloc] initWithFrame:CGRectMake(0, screenH/2 - 390/2, screenW, 390)];
	}

	return self;
}

- (void)loadPlugins {
	NSArray* testPluginNames = [[NSArray alloc] initWithObjects:
								@"prototype.watchface", nil];

#if TARGET_OS_SIMULATOR
	NSString* pluginLocation = @"/opt/simject/FESTIVAL/LockWatch/Watch Faces/";
#else
	NSString* pluginLocation = @"/var/mobile/Library/FESTIVAL/LockWatch/Watch Faces/";
#endif
	NSURL* location = [[NSURL fileURLWithPath:pluginLocation] URLByResolvingSymlinksInPath];
	
	NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:location includingPropertiesForKeys:@[NSFileType] options:(NSDirectoryEnumerationOptions)0 error:nil];
	if ([contents count] == 0) {
		NSLog(@"[LockWatch] No watch faces found.");
		return;
	}
	
	self->loadedWatchFaces = [[NSMutableArray alloc] init];
	
	[testPluginNames enumerateObjectsUsingBlock:^(id defaultPlugin, NSUInteger i, BOOL* stop) {
		NSURL* filePath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", pluginLocation, defaultPlugin]];
		NSBundle* plugin = [[NSBundle alloc] initWithURL:filePath];
		
		if (plugin!= NULL) {
			NSString* pluginIdentifier = [plugin bundleIdentifier];
			NSLog(@"[LockWatch] Found watch face: %@", pluginIdentifier);
			
			[self->loadedWatchFaces addObject:plugin];
		}
	}];
}

- (NSArray*)loadedWatchFaces {
	return self->loadedWatchFaces;
}

- (void)layoutViews {
	float screenW = [[UIScreen mainScreen] bounds].size.width;
	float screenH = [[UIScreen mainScreen] bounds].size.height;
	[self.interfaceView setFrame:CGRectMake(0, screenH/2 - 390/2, screenW, 390)];
}

- (void)startUpdatingTime {
	self->timeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeForCurrentWatchFace) userInfo:nil repeats:YES];
	self->isUpdatingTime = YES;
}
- (void)stopUpdatingTime {
	[self->timeUpdateTimer invalidate];
	self->isUpdatingTime = NO;
	
	[self->currentWatchFace didStopUpdatingTime];
}
- (BOOL)isUpdatingTime {
	return self->isUpdatingTime;
}
- (void)updateTimeForCurrentWatchFace {
	NSDate* date = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *hourComp = [gregorian components:NSCalendarUnitHour fromDate:date];
	NSDateComponents *minuteComp = [gregorian components:NSCalendarUnitMinute fromDate:date];
	NSDateComponents *secondComp = [gregorian components:NSCalendarUnitSecond fromDate:date];
	NSDateComponents *MsecondComp = [gregorian components:NSCalendarUnitNanosecond fromDate:date];
	
	float Hour = ([hourComp hour] >= 12) ? [hourComp hour] - 12 : [hourComp hour];
	float Minute = [minuteComp minute];
	float Second = [secondComp second];
	float Msecond = roundf([MsecondComp nanosecond]/1000000);
	
	if (self->currentWatchFace) {
		[self->currentWatchFace updateTimeWithHour:Hour minute:Minute second:Second msecond:Msecond animated:YES];
	}
}

- (void)setCurrentWatchFace:(id)watchFace {
	self->currentWatchFace = watchFace;
}
- (id)currentWatchFace {
	/*if (self->isInSelection) {
		return nil;
	}*/
	
	return self->currentWatchFace;
}

- (void)setIsInSelection:(BOOL)selection {
	self->isInSelection = selection;
	[[[[[objc_getClass("SBLockScreenManager") sharedInstance] lockScreenViewController] scrollGestureController] scrollView] setScrollEnabled:!selection];
	[self setLockscreenTimeoutEnabled:!selection];
	
	if (selection) {
		[[LWScrollView sharedInstance] scaleDown];
	} else {
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

- (void)setLockscreenTimeoutEnabled:(BOOL)enabled {
	if (enabled) {
		[[objc_getClass("SBBacklightController") sharedInstance] resetLockScreenIdleTimer];
	}
}

@end
