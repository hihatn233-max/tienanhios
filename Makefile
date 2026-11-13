TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FFMaxHack
FFMaxHack_FILES = Tweak.xm MenuView.m ESPOverlayView.m
FFMaxHack_CFLAGS = -fobjc-arc
FFMaxHack_FRAMEWORKS = UIKit Foundation QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
