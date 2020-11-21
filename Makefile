#
# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-LingTiGameAcc
PKG_VERSION:=20201108
PKG_RELEASE:=2
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=eSir Playground <https://github.com/esirplayground/luci-app-LingTiGameAcc>

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI App of LingTiGameAcc
	MAINTAINER:=esirplayground<https://github.com/esirplayground/luci-app-LingTiGameAcc>
	DEPENDS:=+LingTiGameAcc
endef

define Package/$(PKG_NAME)/description
	LuCI App of LingTi Game Accelerator
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) root/etc/config/lingti $(1)/etc/config/lingti
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) root/etc/init.d/lingti $(1)/etc/init.d/lingti

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_CONF) root/etc/uci-defaults/* $(1)/etc/uci-defaults
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR luasrc/* $(1)/usr/lib/lua/luci/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo po/zh-cn/lingti.po $(1)/usr/lib/lua/luci/i18n/lingti.zh-cn.lmo
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
chmod a+x $${IPKG_INSTROOT}/etc/init.d/lingti > /dev/null 2>&1
/etc/init.d/lingti enable > /dev/null 2>&1
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
     /etc/init.d/lingti disable
     /etc/init.d/lingti stop
fi
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
