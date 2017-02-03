#import "LWCore.h"

@interface SBDashBoardMainPageViewController : UIViewController
- (UIViewController*)isolatingViewController;
@end

@interface SBLockScreenDateViewController : UIViewController
@end

@interface SBDashBoardViewController : NSObject {
	SBDashBoardMainPageViewController* _mainPageViewController;
	SBLockScreenDateViewController* _dateViewController;
}

- (SBDashBoardMainPageViewController*)mainPageViewController;
- (SBLockScreenDateViewController*)dateViewController;
@end

@interface SBLockScreenManager : NSObject {
	SBDashBoardViewController* _lockScreenViewController;
}

+ (id)sharedInstance;
- (SBDashBoardViewController*)lockScreenViewController;
@end

@interface SBFLockScreenDateView : UIView
@end
