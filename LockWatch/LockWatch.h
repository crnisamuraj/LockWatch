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
+ (id)sharedInstance;
- (void)resetLockScreenIdleTimer;
- (void)_resetLockScreenIdleTimerWithDuration:(double)arg1 mode:(int)arg2 ;
- (void)setIdleTimerDisabled:(BOOL)arg1 forReason:(id)arg2 ;
@end
