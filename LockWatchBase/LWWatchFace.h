/**
 @class LWWatchFace
 @brief Base class for watch faces
*/

#import <UIKit/UIKit.h>

@class NCMaterialView;

@interface LWWatchFace : UIView {
	UILabel* titleLabel;
	NSString* _titleLabelText;
	
	NCMaterialView* backgroundView;
	UIView* contentView;
	
	UIView* hourHand;
	UIView* minuteHand;
	UIView* secondHand;
}

- (void)setTitleLabelText:(NSString*)newTitleLabel;
- (NCMaterialView*)backgroundView;
- (void)fadeInWithContent:(BOOL)contentFade;
- (void)fadeOutWithContent:(BOOL)contentFade;
- (void)updateTimeWithHour:(CGFloat)Hour minute:(CGFloat)Minute second:(CGFloat)Second msecond:(CGFloat)Msecond;

- (void)didStopUpdatingTime;

@end
