/*!
	@file		LWScrollView.m
	@abstract	The main scroll view containing watch faces, buttons and labels
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWScrollView.h"

@implementation LWScrollView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		int testingCount = 6;
		
		[self setBackgroundColor:[UIColor magentaColor]];
		
		for (int i=0; i<testingCount; i++) {
			UIView* testView = [[UIView alloc] initWithFrame:CGRectMake(312*i + 30*i, 0, 312, 390)];
			[testView setBackgroundColor:[UIColor blueColor]];
			[self addSubview:testView];
		}
		
		[self setContentSize:CGSizeMake((testingCount*312)+(testingCount*30), 390)];
		[self setPagingEnabled:YES];
	}
	
	return self;
}

@end
