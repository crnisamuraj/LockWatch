/*!
	@file		LWInterfaceView.m
	@abstract	The actual view container for all LockWatch views
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWInterfaceView.h"
#import "LWScrollView.h"

@implementation LWInterfaceView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self.scrollView = [[LWScrollView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,390)];
		[self addSubview:self.scrollView];
	}
	
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[self.scrollView setFrame:CGRectMake(0,0,frame.size.width,390)];
}

@end
