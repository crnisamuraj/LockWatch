/*!
	@file		LWScrollView.h
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import <UIKit/UIKit.h>

@class LWScrollViewContainer, WatchButton;

@interface LWScrollView : UIView <UIScrollViewDelegate> {
	CGFloat scrollDelta;
	
	BOOL isScaledDown;
	NSMutableArray* watchFaceViews;
	
	LWScrollViewContainer* _wrapperView;
	UIScrollView* _contentView;
	WatchButton* customizeButton;
	
	UILongPressGestureRecognizer* pressed;
	UITapGestureRecognizer* tapped;
}

@property (nonatomic, retain) UIScrollView* contentView;
@property (nonatomic, retain) LWScrollViewContainer* wrapperView;

+ (id)sharedInstance;

- (void)scaleUp;
- (void)scaleDown;

@end

@interface UIDevice (Private)

@property (nonatomic, readonly) BOOL _supportsForceTouch;

@end
