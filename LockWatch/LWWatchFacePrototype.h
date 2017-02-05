/*!
	@file		LWWatchFacePrototype.h
	@abstract	A watch face prototype used for testing
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import <UIKit/UIKit.h>

@class NCMaterialView;

@interface LWWatchFacePrototype : UIView {
	NCMaterialView* backgroundView;
	UIView* contentView;
}

- (NCMaterialView*)backgroundView;

@end
