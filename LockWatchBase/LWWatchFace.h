#import <UIKit/UIKit.h>

@class NCMaterialView;

@interface LWWatchFace : UIView {
	UILabel* titleLabel;
	NSString* _titleLabelText;
	
	NCMaterialView* backgroundView;
	UIView* contentView;
}

- (void)setTitleLabelText:(NSString*)newTitleLabel;
- (NCMaterialView*)backgroundView;
- (void)fadeInWithContent:(BOOL)contentFade;
- (void)fadeOutWithContent:(BOOL)contentFade;

@end
