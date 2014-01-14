THEOS_DEVICE_IP = stewie.local
TARGET=iphone:7.0:2.0
ARCHS = armv6 armv7 armv7s arm64

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

InfoHider_FRAMEWORKS = UIKit

InfoHider_LIBRARIES = substrate

TWEAK_NAME = InfoHider

InfoHider_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += infohidersettings

SUBPROJECTS += switchesinfohider

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 Preferences"

