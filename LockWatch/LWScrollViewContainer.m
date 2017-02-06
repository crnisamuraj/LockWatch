/*!
	@file		LWScrollViewContainer.m
	@abstract	A container for the main scroll view that acts as a mask
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollViewContainer.h"
#import "LWScrollView.h"

#import <LockWatchBase/WatchButton.h>

@implementation LWScrollViewContainer

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->scrollView = [[LWScrollView alloc] initWithFrame:CGRectMake(-watchFaceSpacing/2, 0, frame.size.width + watchFaceSpacing, frame.size.height)];
		//[self setBackgroundColor:[UIColor magentaColor]];
		[self setClipsToBounds:NO];
		[self addSubview:self->scrollView];
		
		WatchButton* customizeButton = [[WatchButton alloc] initWithFrame:CGRectMake(frame.size.width/2 - 205/2, frame.size.height - 56, 205, 56) withTitle:@"Customize"];
		[self addSubview:customizeButton];
		[self->scrollView setCustomizeButton:customizeButton];
	}
	
	return self;
}

- (UIView *)hitTest:(CGPoint) point withEvent:(UIEvent *)event {
	UIView * scrv = [[self subviews] objectAtIndex:0];
	
	UIView *superView = [super hitTest:point withEvent:event];
	if (superView == self) {
		return scrv;
	}
	
	return superView;
}

@end
