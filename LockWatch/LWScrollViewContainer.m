/*!
	@file		LWScrollViewContainer.m
	@abstract	A container for the main scroll view that acts as a mask
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollViewContainer.h"
#import "LWScrollView.h"

@implementation LWScrollViewContainer

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->scrollView = [[LWScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width + watchFaceSpacing, frame.size.height)];
		[self setBackgroundColor:[UIColor magentaColor]];
		[self setClipsToBounds:YES];
		[self addSubview:self->scrollView];
	}
	
	return self;
}

@end
