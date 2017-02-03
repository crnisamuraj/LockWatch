//
//  LWScrollView.m
//  LockWatch
//
//  Created by Janik Schmidt on 03.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "LWScrollView.h"

@implementation LWScrollView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		int testingCount = 6;
		
		self->contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (testingCount*312)+(testingCount*30), 390)];
		[self->contentView setBackgroundColor:[UIColor magentaColor]];
		
		[self addSubview:self->contentView];
		
		for (int i=0; i<testingCount; i++) {
			UIView* testView = [[UIView alloc] initWithFrame:CGRectMake(312*i + 30*i, 0, 312, 390)];
			[testView setBackgroundColor:[UIColor blueColor]];
			[self->contentView addSubview:testView];
		}
		
		[self setContentSize:CGSizeMake((testingCount*312)+(testingCount*30), 390)];
		[self setPagingEnabled:YES];
	}
	
	return self;
}

@end
