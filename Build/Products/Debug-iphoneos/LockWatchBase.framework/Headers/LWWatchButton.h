//
//  LWWatchButton.h
//  LockWatch
//
//  Created by Janik Schmidt on 13.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCMaterialView;

@interface LWWatchButton : UIButton {
	NCMaterialView* backgroundView;
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)title;

@end
