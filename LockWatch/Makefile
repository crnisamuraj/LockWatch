export THEOS_DEVICE_IP=192.168.178.98
export THEOS_DEVICE_PORT=22
export GO_EASY_ON_ME = 1

export PACKAGE_VERSION = 0.0.1-beta1

# Build for a physical device
TARGET = iphone:latest
ARCHS = armv7 arm64

# Build for the simulator
#TARGET = simulator:clang
#ARCHS = x86_64

include /opt/theos/makefiles/common.mk

TWEAK_NAME = LockWatch
LockWatch_LDFLAGS += -F./
LockWatch_CFLAGS=-I ./include/LockWatchBase -I ./include
LockWatch_FRAMEWORKS += AudioToolbox LockWatchBase
LockWatch_FILES = LockWatch.xm easing.c CAKeyframeAnimation+AHEasing.m LWCore.m LWInterfaceView.m LWScrollViewContainer.m LWScrollView.m

include /opt/theos/makefiles/tweak.mk

before-all::
	@rm -Rf /var/folders/gf/5ygq87ms78s4pvpvs8rdrm500000gn/C/org.llvm.clang.*/

# Copy the compiled dylib to simject's directory
# You don't need to comment this when building for a device,
# only when you don't use simject at all
after-all::
	@echo Copying .dylib to /opt/simject
	@cp $(THEOS_OBJ_DIR)/LockWatch.dylib /opt/simject
	@cp LockWatch.plist /opt/simject

after-install::
	install.exec "killall -9 SpringBoard"
