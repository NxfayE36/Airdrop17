TARGET := iphone:clang:latest:15.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AirDrop17
AirDrop17_FILES = AirDrop17/Tweak.m
AirDrop17_FRAMEWORKS = UIKit CoreGraphics QuartzCore
AirDrop17_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

THEOS_PACKAGE_SCHEME = rootless
