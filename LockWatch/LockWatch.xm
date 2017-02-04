#import "LockWatch.h"
#import "LWInterfaceView.h"

LWCore* lockWatchCore;
SBDashBoardMainPageViewController* mainPage;

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig(arg1);
	
	lockWatchCore = [[LWCore alloc] init];
	
	SBLockScreenManager* lsManager = [%c(SBLockScreenManager) sharedInstance];
	SBDashBoardViewController* dashBoard = [lsManager lockScreenViewController];
	mainPage = [dashBoard mainPageViewController];
	
	[[mainPage view] insertSubview:lockWatchCore.interfaceView atIndex:0];
	[[mainPage isolatingViewController].view setHidden:YES];
}

%end

%hook SBFLockScreenDateView

- (void)layoutSubviews {
	[[mainPage isolatingViewController].view setHidden:YES];
	%orig;
}

%end

%hook SBDashBoardViewController

-(void)startLockScreenFadeInAnimationForSource:(int)arg1 {
	[[mainPage isolatingViewController].view setHidden:YES];
	%orig(arg1);
}

%new
- (SBDashBoardScrollGestureController*)scrollGestureController {
	return MSHookIvar<SBDashBoardScrollGestureController*>(self,"_scrollGestureController");
}

%end

%hook SBDashBoardScrollGestureController

%new
- (SBPagedScrollView*)scrollView {
	return MSHookIvar<SBPagedScrollView*>(self,"_scrollView");
}

%end

%hook SBBacklightController

- (double)defaultLockScreenDimInterval {
	lockWatchCore.defaultDimInterval = %orig;
	return %orig;
}

%end
