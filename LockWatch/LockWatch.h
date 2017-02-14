#import "substrate.h"
#import "LWCore.h"

@interface SBDashBoardMainPageViewController : UIViewController
- (UIViewController*)isolatingViewController;
@end

@interface SBLockScreenDateViewController : UIViewController
@end

@interface SBPagedScrollView : UIScrollView
@end

@interface SBDashBoardScrollGestureController : NSObject {
	SBPagedScrollView* _scrollView;
}

- (SBPagedScrollView*)scrollView;
@end

@interface SBDashBoardViewController : NSObject {
	SBDashBoardMainPageViewController* _mainPageViewController;
	SBLockScreenDateViewController* _dateViewController;
	SBDashBoardScrollGestureController* _scrollGestureController;
}

- (SBDashBoardMainPageViewController*)mainPageViewController;
- (SBLockScreenDateViewController*)dateViewController;
- (SBDashBoardScrollGestureController*)scrollGestureController;
@end

@interface SBLockScreenManager : NSObject {
	SBDashBoardViewController* _lockScreenViewController;
}

+ (id)sharedInstance;
- (SBDashBoardViewController*)lockScreenViewController;
@end

@interface SBFLockScreenDateView : UIView
@end

@interface SBBacklightController : NSObject
-(NSString *)dashBoardIdentifier;
-(void)resetIdleTimerAndUndimForSource:(long long)arg1 ;
-(void)startAllowingIdleTimer;
-(void)setBacklightFactor:(float)arg1 source:(long long)arg2 ;
-(void)autoLockPrefsChanged;
-(BOOL)screenIsOn;
-(void)cancelLockScreenIdleTimer;
-(void)resetLockScreenIdleTimer;
-(void)preventIdleSleepForNumberOfSeconds:(float)arg1 ;
-(void)setBacklightFactorToZeroForProx;
-(void)restoreBacklightFactorForProx;
-(BOOL)wouldHandleButtonEvent:(id)arg1 ;
-(BOOL)screenIsDim;
-(BOOL)isPendingScreenUnblankAfterCACommit;
-(BOOL)shouldTurnOnScreenForBacklightSource:(long long)arg1 ;
-(double)defaultLockScreenDimIntervalWhenNotificationsPresent;
-(double)defaultLockScreenDimInterval;
-(void)_userEventsDidIdle;
-(void)pocketStateMonitor:(id)arg1 pocketStateDidChangeFrom:(long long)arg2 to:(long long)arg3 ;
-(void)startFadeOutAnimationFromLockSource:(int)arg1 ;
-(void)reloadDefaults;
-(void)_deferredScreenUnblankDone;
-(void)_batterySaverModeDidChange:(id)arg1 ;
-(void)_setBacklightFactorToZeroForProx;
-(void)_cancelSetBacklightFactorToZeroAfterDelay;
-(void)_clearAutoLockTimer;
-(void)_setBKEventTimerMode:(int)arg1 withDuration:(float)arg2 ;
-(void)_resetIdleTimerAndUndim:(BOOL)arg1 source:(long long)arg2 ;
-(void)_sendResetIdleTimerAction;
-(BOOL)_lockScreenWantsUserEventNotifications;
-(double)_nextLockTimeDuration;
-(double)_nextIdleTimeDuration;
-(void)adjustIdleLockDuration:(double*)arg1 idleDimDuration:(double*)arg2 ;
-(void)_performDeferredBacklightRampWorkWithInfo:(id)arg1 ;
-(void)preventIdleSleep;
-(void)dimForIdleWarning;
-(void)_autoLockTimerFired:(id)arg1 ;
-(void)_lockScreenDimTimerFired;
-(void)_didIdle;
-(void)_resetLockScreenIdleTimerWithDuration:(double)arg1 mode:(int)arg2 ;
-(void)allowIdleSleep;
-(void)_startFadeOutAnimationFromLockSource:(int)arg1 ;
-(void)_undimFromSource:(long long)arg1 ;
-(double)_currentLockScreenIdleTimerInterval;
-(void)turnOnScreenFullyWithBacklightSource:(long long)arg1 ;
-(void)setBacklightFactorPending:(float)arg1 ;
-(void)_userEventOccurred;
-(void)_userEventPresenceTimerExpired;
-(void)_requestedUserEventNotificationOccurred;
-(id)init;
-(id)idleTimerDisabledReasons;
-(BOOL)handleEvent:(id)arg1 ;
-(void)setIdleTimerDisabled:(BOOL)arg1 forReason:(id)arg2 ;
-(void)resetLockScreenIdleTimerWithDuration:(double)arg1 ;
-(long long)participantState;
-(void)clearIdleTimer;
-(void)resetIdleTimer;
@end
