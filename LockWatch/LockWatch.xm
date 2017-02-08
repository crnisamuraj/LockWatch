#import "LockWatch.h"
#import "LWInterfaceView.h"

LWCore* lockWatchCore;
SBDashBoardMainPageViewController* mainPage;

BOOL hasNotifications;
BOOL mediaControlsVisible;

static void setLockWatchVisibility() {
	[[mainPage isolatingViewController].view setHidden:(!hasNotifications && !mediaControlsVisible)];
	
	[lockWatchCore.interfaceView setHidden:mediaControlsVisible];
	[lockWatchCore setIsInMinimizedView:(hasNotifications && !mediaControlsVisible)];
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig(arg1);
	
	lockWatchCore = [[LWCore alloc] init];
	
	SBLockScreenManager* lsManager = [%c(SBLockScreenManager) sharedInstance];
	SBDashBoardViewController* dashBoard = [lsManager lockScreenViewController];
	mainPage = [dashBoard mainPageViewController];
	
	[[mainPage view] insertSubview:lockWatchCore.interfaceView atIndex:0];
	setLockWatchVisibility();
}

%end

%hook SBFLockScreenDateView

- (void)layoutSubviews {
	// Disabling this as long as watch faces don't work
	//[MSHookIvar<UILabel *>(self,"_timeLabel") removeFromSuperview];
	//[MSHookIvar<UILabel *>(self,"_dateSubtitleView") removeFromSuperview];
	
	[lockWatchCore setFrameForMinimizedView:self.frame];
	[lockWatchCore layoutViews];
	setLockWatchVisibility();
	
	%orig;
}

%end

%hook SBDashBoardViewController

-(void)startLockScreenFadeInAnimationForSource:(int)arg1 {
	setLockWatchVisibility();
	
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


// Fix for invisible notifications/media controls (temporary)

%hook SBDashBoardNotificationListViewController

-(void)_setListHasContent:(BOOL)arg1 {
	%orig(arg1);
	
	hasNotifications = arg1;
	setLockWatchVisibility();
}

%end

%hook SBDashBoardMediaArtworkViewController

-(void)willTransitionToPresented:(BOOL)arg1 {
	%orig(arg1);
	
	mediaControlsVisible = arg1;
	setLockWatchVisibility();
}

%end
