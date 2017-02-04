/*!
	@file		LWWatchFacePrototype.h
	@abstract	A watch face prototype used for testing
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import "LWWatchFacePrototype.h"
#import <objc/runtime.h>
#import "NCMaterialView.h"

@implementation LWWatchFacePrototype

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		NCMaterialView* contentView = [objc_getClass("NCMaterialView") materialViewWithStyleOptions:2];
		[contentView setFrame:CGRectMake(0, 0, 312, 390)];
		[contentView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.45]];
		[self addSubview:contentView];
		
		[self setClipsToBounds:YES];
		[self.layer setCornerRadius:15.0];
	}
	
	return self;
}

@end
