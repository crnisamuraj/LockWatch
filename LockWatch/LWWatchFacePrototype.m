/*!
	@file		LWWatchFacePrototype.h
	@abstract	A watch face prototype used for testing
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWWatchFacePrototype.h"
#import <objc/runtime.h>
#import <LockWatchBase/LockWatchBase.h>
#import "NCMaterialView.h"

@implementation LWWatchFacePrototype

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		self->backgroundView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
		[self->backgroundView setFrame:CGRectMake(-18, -18, 348, 426)];
		[self->backgroundView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.45]];
		[self->backgroundView.layer setCornerRadius:15.0];
		[self->backgroundView setClipsToBounds:YES];
		[self addSubview:self->backgroundView];
		
		UIView* testView = [Indicators indicatorsForSimpleWithDetail:1];
		[self addSubview:testView];
		
		[self setClipsToBounds:NO];
	}
	
	return self;
}

- (NCMaterialView*)backgroundView {
	return self->backgroundView;
}

@end
