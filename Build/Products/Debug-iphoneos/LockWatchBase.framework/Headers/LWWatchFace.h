/**
 @class LWWatchFace
 @brief Base class for watch faces
*/

#import <UIKit/UIKit.h>

#define kWatchColorWhite [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0]
#define kWatchColorRed [UIColor colorWithRed:0.87 green:0.03 blue:0.13 alpha:1.0]
#define kWatchColorOrange [UIColor colorWithRed:1 green:0.31 blue:0.18 alpha:1.0]
#define kWatchColorLightOrange [UIColor colorWithRed:1 green:0.58 blue:0 alpha:1.0]
#define kWatchColorYellow [UIColor colorWithRed:1 green:0.93 blue:0.19 alpha:1.0]
#define kWatchColorGreen [UIColor colorWithRed:0.54 green:0.89 blue:0.15 alpha:1.0]
#define kWatchColorTurqoise [UIColor colorWithRed:0.61 green:0.83 blue:0.8 alpha:1.0]
#define kWatchColorLightBlue [UIColor colorWithRed:0.41 green:0.77 blue:0.86 alpha:1.0]
#define kWatchColorBlue [UIColor colorWithRed:0.09 green:0.7 blue:0.98 alpha:1.0]
#define kWatchColorMidnightBlue [UIColor colorWithRed:0.37 green:0.51 blue:0.74 alpha:1.0]
#define kWatchColorPurple [UIColor colorWithRed:0.6 green:0.48 blue:0.96 alpha:1.0]
#define kWatchColorLavender [UIColor colorWithRed:0.69 green:0.6 blue:0.65 alpha:1.0]
#define kWatchColorPink [UIColor colorWithRed:1 green:0.34 blue:0.38 alpha:1.0]
#define kWatchColorVintageRose [UIColor colorWithRed:0.95 green:0.67 blue:0.64 alpha:1.0]
#define kWatchColorWalnut [UIColor colorWithRed:0.69 green:0.52 blue:0.38 alpha:1.0]
#define kWatchColorStone [UIColor colorWithRed:0.68 green:0.6 blue:0.5 alpha:1.0]
#define kWatchColorAntiqueWhite [UIColor colorWithRed:0.83 green:0.71 blue:0.58 alpha:1.0]


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

- (void)prepareForInit;
- (void)updateTimeWithHour:(CGFloat)Hour minute:(CGFloat)Minute second:(CGFloat)Second msecond:(CGFloat)Msecond animated:(BOOL)animated;

- (void)didStartUpdatingTime;
- (void)didStopUpdatingTime;

@end
