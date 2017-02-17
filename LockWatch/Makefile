# MAKEFILE 2

# Configure your device details here
export THEOS_DEVICE_IP=192.168.178.38
export THEOS_DEVICE_PORT=22

# Set the package version
export PACKAGE_VERSION = 0.0.1-beta1

# Configure the target here
TARGET = iphone:latest		# Phyiscal devices
#TARGET = simulator:clang	# Simulator


# DO NOT EDIT ANYTHING BEYOND THIS POINT
export GO_EASY_ON_ME = 1
export FRAMEWORK_PATH=../Build/Products/Debug-$(PLATFORM_NAME)

include /opt/theos/makefiles/common.mk

TWEAK_NAME = LockWatch
LockWatch_LDFLAGS += -F$(FRAMEWORK_PATH)
LockWatch_CFLAGS=-I ./include/LockWatchBase -I ./include
LockWatch_FRAMEWORKS += AudioToolbox LockWatchBase
LockWatch_FILES = LockWatch.xm easing.c CAKeyframeAnimation+AHEasing.m LWCore.m LWInterfaceView.m LWScrollViewContainer.m LWScrollView.m

include /opt/theos/makefiles/tweak.mk

# Copy the compiled dylib to simject's directory
# You don't need to comment this when building for a device,
# only when you don't use simject at all
after-all::
	@echo Copying .dylib to /opt/simject
	@cp $(THEOS_OBJ_DIR)/LockWatch.dylib /opt/simject
	@cp LockWatch.plist /opt/simject

after-install::
	install.exec "killall -9 SpringBoard"
