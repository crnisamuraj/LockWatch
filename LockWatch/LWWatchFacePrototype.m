/*!
	@file		LWWatchFacePrototype.h
	@abstract	A watch face prototype used for testing
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWWatchFacePrototype.h"
#import <objc/runtime.h>

@implementation LWWatchFacePrototype

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		_UIBackdropView* contentView = [[_UIBackdropView alloc] initWithStyle:0];
		[contentView setBlurRadius:30.0];
		[contentView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.45]];
		[self addSubview:contentView];
		
		[self setClipsToBounds:YES];
		[self.layer setCornerRadius:12.0];
	}
	
	return self;
}

@end
