//
//  LWScrollViewContainer.m
//  LockWatch
//
//  Created by Janik Schmidt on 03.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

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
