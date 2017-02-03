export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222
export GO_EASY_ON_ME = 1

export PACKAGE_VERSION = 0.0.1-beta1

#TARGET = iphone:latest
#ARCHS = armv7 arm64

TARGET = simulator:clang
ARCHS = x86_64

include /opt/theos/makefiles/common.mk

TWEAK_NAME = LockWatch
LockWatch_FILES = LockWatch.xm LWCore.m

include /opt/theos/makefiles/tweak.mk

after-all::
	@echo Copying .dylib to /opt/simject
	@cp $(THEOS_OBJ_DIR)/LockWatch.dylib /opt/simject
	@cp LockWatch.plist /opt/simject

after-install::
	install.exec "killall -9 SpringBoard"
