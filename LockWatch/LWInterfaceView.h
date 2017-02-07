/*!
	@file		LWInterfaceView.h
	@abstract	The actual view container for all LockWatch views
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import <UIKit/UIKit.h>

@class LWScrollViewContainer, LWScrollView;

@interface LWInterfaceView : UIView <UIScrollViewDelegate> {
	LWScrollViewContainer* scrollViewContainer;
	LWScrollView* _scrollView;
}

@property (nonatomic, retain) LWScrollView* scrollView;

@end
