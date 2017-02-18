# LockWatch
Display watch faces on your lockscreen - inspired by Apple Watch

## Description
LockWatch is back! And this time it's better than ever before! This tweak allows you to display watchfaces on your iOS lockscreen inspired by Apple Watch.

Every watch face is recreated 1:1 and can be configured either by force-touching them (as seen on Apple Watch) or the optional dedicated configuration app.

## Usage
If you have used an Apple Watch before, you should know how LockWatch works.

* Press firmly to enter Selection Mode (Long Press on non-3D Touch devices)
* Swipe to select a watch face
* Tap a watch face to exit Selection Mode
* Or tap "Customize" to customize a watch face (not available yet)

## Planned watch faces
* Numerals 
* Utility 
* Simple 
* Color 
* Chronograph
* X-Large
* Weather

## Localizations
You can help contributing to this project again by adding various localizations (English and German will be included by default). Just fork the "Localization" branch (if that works, I don't know yet), add your Localization if it's not on the list below, and submit a pull request.

**Completed localizations**

* ~~English~~ (Not yet) 
* ~~German~~ (Not yet)

## Compatibility
This version of LockWatch will only be compatible with iOS 10 at first, with iOS 9 (and maybe iOS 8) compatibility being added at a later point.

Compiling is recommended using the iOS 10.2 SDK

## Building LockWatch
LockWatch supports both iOS devices and the iOS Simulator (using simject, more on that here: https://github.com/angelXwind/simject). To build for the Simulator, select the "Build" scheme and any Simulator target. To build for a device, use the "Build" scheme, select "Generic iOS Device" or any connected iOS Device and set the `TARGET` variable in the Makefile to `ìphone:latest` (comments should help you out).

Remember to include the LockWatchBase.framework headers. Copy every .h file from the built framework inside `./LockWatch/LockWatch/LockWatchBase.framework/Headers` to `./LockWatch/LockWatch/include/LockWatchBase/`and you should be good to go.

To install LockWatch to your device, use the "Install" scheme instead of the "Build" scheme. The rest of the settings stays the same for iOS devices. Installing also requires device IP and port to be set. Using SSH over USB is recommended.

To install watch faces, see the "Plugins" section below.

## Plugins
Just like the original, LockWatch can be extended using plugins. These plugins inherit from the base class `LWWatchFace` that includes the basic setup, but you can do anything with your watch face, including (but not limited to)
* show Nyan cat
* show time in binary format
* show your favorite image (maybe you should stick to using a wallpaper for this one)

Watch faces are bundles that are compiled for iOS. Create a new Xcode project and select "Bundle" from the macOS tab. Go to your projects build settings set the base SDK to either "Latest iOS" or any other installed iOS SDK and disable Bitcode (BITCODE_ENABLED). Then, import LockWatchBase.framework. You need to compile the framework yourself.
Create a new class with a unique name and make it a subclass of `LWWatchFace`. You can either choose to create a watch face out of existing templates or something entirely new (documentation will follow.)
**To make it run on your device, you need to codesign it.** Add a new "Run Script Phase" and add the following code:
`codesign --force --sign - --timestamp=none $CODESIGNING_FOLDER_PATH/$PRODUCT_NAME`

Finally, compile your watch face for either "Generic iOS Device" or any other connected device and copy the build result to
`/var/mobile/Library/FESTIVAL/LockWatch/Watch Faces/`
(You should see some watch faces already. If not, you're in the wrong place)
Restart SpringBoard, and if everything goes well, you should be able to select your watch face from Selection Mode.
