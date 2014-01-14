THEOS_DEVICE_IP = stewie.local
TARGET=iphone:7.0:2.0
ARCHS = armv6 armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = SwitchesInfoHider

SwitchesInfoHider_FILES = SwitchesInfoHider.mm

SwitchesInfoHider_INSTALL_PATH = /Library/PreferenceBundles

SwitchesInfoHider_FRAMEWORKS = UIKit

SwitchesInfoHider_PRIVATE_FRAMEWORKS = Preferences

SwitchesInfoHider_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/bundle.mk

