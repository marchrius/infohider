THEOS_DEVICE_IP = stewie.local
TARGET=iphone:7.0:2.0
ARCHS = armv6 armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = InfoHiderSettings

InfoHiderSettings_FILES = InfoHiderSettings.mm

InfoHiderSettings_INSTALL_PATH = /Library/PreferenceBundles

InfoHiderSettings_FRAMEWORKS = UIKit

InfoHiderSettings_PRIVATE_FRAMEWORKS = Preferences AppleAccount

InfoHiderSettings_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InfoHiderSettings.plist$(ECHO_END)