//
//  Indicators.h
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Indicators : NSObject

+ (UIView*)indicatorsForUtilityWithDetail:(int)detail;
+ (UIView*)indicatorsForSimpleWithDetail:(int)detail;
+ (UIView*)indicatorsForColorWithAccentColor:(UIColor*)accentColor;
+ (UIView*)indicatorsForChronograph;

@end
