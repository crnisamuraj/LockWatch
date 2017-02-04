/*!
	@file		LWInterfaceView.m
	@abstract	The actual view container for all LockWatch views
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

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
