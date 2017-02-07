//
//  WatchButton.m
//  LockWatch
//
//  Created by Janik Schmidt on 06.02.17.
//  Copyright © 2017 Janik Schmidt. All rights reserved.
//

#import "WatchButton.h"
#import <objc/runtime.h>
#import "NCMaterialView.h"

@implementation WatchButton

- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)title {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
		[self->backgroundView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self->backgroundView.layer setCornerRadius:8.0];
		[self->backgroundView setClipsToBounds:YES];
		[self addSubview:self->backgroundView];
		
		[self setTitle:title forState:UIControlStateNormal];
		[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self.titleLabel setFont:[UIFont systemFontOfSize:30]];
	}
	
	return self;
}

@end
