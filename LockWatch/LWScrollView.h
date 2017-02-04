/*!
	@file		LWScrollView.h
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import <UIKit/UIKit.h>

@interface LWScrollView : UIScrollView {
	BOOL isScaledDown;
	UITapGestureRecognizer* tapped;
}

+ (id)sharedInstance;

- (void)scaleUp;
- (void)scaleDown;

@end
