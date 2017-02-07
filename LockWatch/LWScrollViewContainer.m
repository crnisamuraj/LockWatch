/*!
	@file		LWScrollViewContainer.m
	@abstract	A container for the main scroll view that acts as a mask
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollViewContainer.h"
#import "LWScrollView.h"

#define scaleDownFactor (188.0/312.0)

@implementation LWScrollViewContainer

- (UIView *)hitTest:(CGPoint) point withEvent:(UIEvent *)event {
	UIView* view = [super hitTest:point withEvent:event];
	
	if (view == self) {
		return [[self subviews] objectAtIndex:0];
	}
	
	return view;
}

@end
