//
//  Hands.h
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hands : NSObject

+ (UIView*)hourHandWithAccentColor:(UIColor*)accentColor andChronographStyle:(BOOL)chronoStyle;
+ (UIView*)minuteHandWithAccentColor:(UIColor*)accentColor andChronographStyle:(BOOL)chronoStyle;
+ (UIView*)secondHandWithAccentColor:(UIColor*)accentColor;
+ (UIView*)chronoSecondHand;

@end
