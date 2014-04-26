include theos/makefiles/common.mk

TWEAK_NAME = QuickHide
QuickHide_FILES = Tweak.xm
QuickHide_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
