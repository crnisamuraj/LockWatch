@interface NCMaterialView : UIView

+(id)materialViewWithStyleOptions:(unsigned long long)arg1 ;
-(void)dealloc;
-(NSString *)groupName;
-(void)setGroupName:(NSString *)arg1 ;
-(UIView *)colorInfusionView;
-(void)setColorInfusionView:(UIView *)arg1 ;
-(id)initWithStyleOptions:(unsigned long long)arg1 ;
-(void)_configureIfNecessary;
-(void)_reduceTransparencyStatusDidChange;
-(void)_configureColorInfusionViewIfNecessary;
-(void)_configureBackdropViewIfNecessary;
-(void)_configureLightOverlayViewIfNecessary;
-(void)_configureWhiteOverlayViewIfNecessary;
-(void)_configureCutoutOverlayViewIfNecessary;
-(void)_setSubviewsContinuousCornerRadius:(double)arg1 ;
-(void)_setColorInfusionViewAlpha:(double)arg1 ;
-(double)grayscaleValue;
-(void)setGrayscaleValue:(double)arg1 ;
-(double)_colorInfusionViewAlpha;
-(double)_subviewsContinuousCornerRadius;

@end
