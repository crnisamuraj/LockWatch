/*!
	@file		LWScrollViewContainer.h
	@abstract	A container for the main scroll view that acts as a mask
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import <UIKit/UIKit.h>

#define watchFaceSpacing 30

@class LWScrollView;

@interface LWScrollViewContainer : UIView {
	LWScrollView* scrollView;
}

@end
