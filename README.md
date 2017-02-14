# LockWatch
Display watch faces on your lockscreen - inspired by Apple Watch

## Description
LockWatch is back! And this time it's better than ever before! This tweak allows you to display watchfaces on your iOS lockscreen inspired by Apple Watch.

Every watch face is recreated 1:1 and can be configured either by force-touching them (as seen on Apple Watch) or the optional dedicated configuration app.

## Available watch faces
* Numerals 
* Utility 
* Simple 
* Color 
* Chronograph
* X-Large
* Weather

**Note:** Due to a severe issue involving code signing, plugins will not be available as long as this issue remains unsolved (see http://stackoverflow.com/questions/42133980/ios-code-signature-invalid-required-code-signature-missing for more information)

## Localizations
You can help contributing to this project again by adding various localizations (English and German will be included by default). Just fork the "Localization" branch (if that works, I don't know yet), add your Localization if it's not on the list below, and submit a pull request.

**Completed localizations**

* ~~English~~ (Not yet) 
* ~~German~~ (Not yet)

## Plugins
Just like the previous version of LockWatch, this tweak is extensible. In fact, the stock watch faces are just plugins. There will be a plugin API and a template to create your own watch faces.

## Compatibility
This version of LockWatch will only be compatible with iOS 10 at first, with iOS 9 (and maybe iOS 8) compatibility being added at a later point.

Compiling is recommended using the iOS 10.2 SDK

## Building LockWatch
To build LockWatch, you have two targets: "Simulator" and "Device".

"Simulator" is made for use with simject to test LockWatch inside the iOS Simulator. For more information on simject, visit https://github.com/angelXwind/simject. This target also requires LockWatchBase.framework. Build it using the "LockWatchBase" target and copy it to to project directory and 
`/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/`


"Device" builds LockWatch for a physical device connected via USB. As yalu102 makes SSH only listen on localhost, you need to set up SSH via USB for this (http://iphonedevwiki.net/index.php/SSH_Over_USB).

Building also requires the correct targets and architectures set for either Simulator or Device. Have a look at the makefile and (un-)comment the targets and architectures you need.
