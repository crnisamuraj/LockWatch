#import "LockWatch.h"

LWCore* lockWatchCore;


%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig(arg1);
	
	lockWatchCore = [[LWCore alloc] init];
	
	SBLockScreenManager* lsManager = [%c(SBLockScreenManager) sharedInstance];
	SBDashBoardViewController* dashBoard = [lsManager lockScreenViewController];
	SBDashBoardMainPageViewController* mainPage = [dashBoard mainPageViewController];
	
	[[mainPage view] insertSubview:lockWatchCore.interfaceView atIndex:0];
}

%end
