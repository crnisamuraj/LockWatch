/*!
	@file		LWWatchFacePrototype.h
	@abstract	A watch face prototype used for testing
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWWatchFacePrototype.h"

@implementation LWWatchFacePrototype

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		[self setBackgroundColor:[UIColor blueColor]];
		[self setUserInteractionEnabled:NO];
	}
	
	return self;
}

@end
