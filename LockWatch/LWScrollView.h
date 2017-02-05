/*!
	@file		LWScrollView.h
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import <UIKit/UIKit.h>

@interface LWScrollView : UIScrollView {
	BOOL isScaledDown;
	UITapGestureRecognizer* tapped;
	NSMutableArray* watchFaceViews;
}

+ (id)sharedInstance;

/**
 Leave selection mode
 */
- (void)scaleUp;

/**
 Enter selection mode
 */
- (void)scaleDown;


/**
 Return every loaded watch face view

 @return Loaded watch face views
 */
- (NSArray*)watchFaceViews;

@end
