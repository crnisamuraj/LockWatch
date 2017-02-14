/*!
	@file		LWCore.h
	@abstract	The core of LockWatch, managing everything from Timers to Plugins
	@copyright	(c) 2015-2017 FESTIVAL Development
 */

#import <UIKit/UIKit.h>

@class LWInterfaceView, LWScrollViewContainer, LWWatchFace;

@interface LWCore : NSObject {
	NSMutableArray* loadedWatchFaces;

	BOOL isUpdatingTime;
	NSTimer* timeUpdateTimer;
	
	LWScrollViewContainer* mainScrollView;
	LWWatchFace* currentWatchFace;
	BOOL isInSelection;
	
	CGRect minimizedFrame;
	BOOL isInMinimizedView;
}

/*
 *--*- LWInterfaceView : UIView
	|
	*--*- LWScrollViewContainer : UIView
	   |
	   *--*- LWScrollView : UIView <UIScrollViewDelegate>
		  |
		  *---- UIScrollView
*/

/**
 The main view for LockWatch
 */
@property (nonatomic, strong) LWInterfaceView* interfaceView;
@property (nonatomic) double defaultDimInterval;


/**
 Return every loaded watch face

 @return An array containing the bundles for every loaded watch face
 */
- (NSArray*)loadedWatchFaces;


/**
 Layout any views after interface change (eg. orientation)
 */
- (void)layoutViews;

/**
 The global core instance

 @return A shared instance of LWCore to be used anywhere
 */
+ (id)sharedInstance;

/**
 Set the core to start updating the time in the current watch face
 */
- (void)startUpdatingTime;
/**
 Set the core to stop updating time
 */
- (void)stopUpdatingTime;
/**
 Check if the core is currently updating time

 @return The core is currently updating the time
 */
- (BOOL)isUpdatingTime;

- (void)updateTimeForCurrentWatchFace;

/**
 Set the current watch face (nil if in selection mode)

 @param watchFace The current watch face
 */
- (void)setCurrentWatchFace:(id)watchFace;
/**
 Returns the current watch face (nil if in selection mode)

 @return The current watch face
 */
- (id)currentWatchFace;

/**
 Enable or disable selection mode

 @param selection Enable or disable selection mode
 */
- (void)setIsInSelection:(BOOL)selection;
/**
 Check if the core is currently in selection mode

 @return Selection mode enabled or disabled
 */
- (BOOL)isInSelection;


/**
 Sets the frame for the minimized view based on the lockscreen clock container

 @param frame The frame describing the lockscreen clock container
 */
- (void)setFrameForMinimizedView:(CGRect)frame;

/**
 Enables or disables the minimized view

 @param isMinimized A boolean value determining if there are notifications displayed on the lockscreen
 */
- (void)setIsInMinimizedView:(BOOL)isMinimized;

- (void)setLockscreenTimeoutEnabled:(BOOL)enabled;
@end
