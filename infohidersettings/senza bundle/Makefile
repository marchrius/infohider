export THEOS_DEVICE_IP = 10.1.1.3
export TARGET=iphone:7.0:2.0
export ARCHS = armv6 armv7 arm64

include theos/makefiles/common.mk

#BUNDLE_NAME = InfoHiderSettings

InfoHiderSettings_INSTALL_PATH = /Library/PreferenceLoader

InfoHiderSettings_FRAMEWORKS = UIKit

InfoHiderSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InfoHiderSettings$(ECHO_END)
	$(ECHO_NOTHING)cp entry.txt $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InfoHiderSettings/InfoHiderSettings.plist$(ECHO_END)
	$(ECHO_NOTHING)cp InfoHider.png $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InfoHiderSettings/InfoHider.png$(ECHO_END)
	$(ECHO_NOTHING)cp "InfoHider@2x.png" $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InfoHiderSettings/"InfoHider@2x.png"$(ECHO_END)
#Copia
	$(ECHO_NOTHING)cp -r Italian.lproj $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InfoHiderSettings/Italian.lproj$(ECHO_END)