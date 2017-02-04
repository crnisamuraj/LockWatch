//
//  LWInterfaceView.m
//  LockWatch
//
//  Created by Janik Schmidt on 04.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "LWInterfaceView.h"

@implementation LWInterfaceView

- (UIView *)hitTest:(CGPoint) point withEvent:(UIEvent *)event {
	UIView * scrv = [[[[self subviews] objectAtIndex:0] subviews] objectAtIndex:0];
	
	UIView *superView = [super hitTest:point withEvent:event];
	if (superView == self) {
		return scrv;
	}
	
	return superView;
}

@end
