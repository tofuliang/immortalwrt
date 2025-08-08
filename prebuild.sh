#!/usr/bin/env bash

export ReleaseVersion="$(git rev-parse --short HEAD^)-$(date +%Y.%m.%d)"
# ROOT=$(pwd)
# sed -i "/helloworld/d" "feeds.conf.default"
# sed -i "/passwall/d" "feeds.conf.default"
# sed -i "/cups/d" "feeds.conf.default"
# echo "src-git helloworld https://github.com/fw876/helloworld" >> "feeds.conf.default"
# echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall" >> "feeds.conf.default"
# echo "src-git cups https://github.com/tofuliang/lede-cups" >> "feeds.conf.default"
./scripts/feeds clean
./scripts/feeds update -a -f

# rm -fr luci-compat-app-smartdns
# (git clone --depth 1 https://github.com/pymumu/smartdns smartdns_repo;
# mv smartdns_repo/package/luci-compat luci-compat-app-smartdns;rm -fr smartdns_repo)

# cd luci-compat-app-smartdns
# mkdir {luasrc,po,root}
# mv files/etc root/etc
# mv files/luci/i18n po/zh-cn
# rm -fr files/luci/i18n
# mv files/luci/*  luasrc/
# rm -fr ../package/lean/luci-app-smartdns
# mkdir ../package/lean/luci-app-smartdns

# cat >> Makefile <<EOF
# # This is free software, licensed under the Apache License, Version 2.0 .

# include \$(TOPDIR)/rules.mk

# LUCI_TITLE:=Luci for smartdns server
# LUCI_DEPENDS:=+smartdns
# LUCI_PKGARCH:=all
# PKG_NAME:=luci-app-smartdns
# PKG_VERSION:=1
# PKG_RELEASE:=1

# include \$(TOPDIR)/feeds/luci/luci.mk

# # call BuildPackage - OpenWrt buildroot signature

# EOF
# mv {luasrc,po,root,Makefile} ../package/lean/luci-app-smartdns
# cd .. && rm -fr luci-compat-app-smartdns
# cd package/lean
# rm -fr smartdns
# (git clone --depth 1 https://github.com/pymumu/smartdns smartdns_repo;
# mv smartdns_repo/package/openwrt smartdns;rm -fr smartdns_repo)

# # 创建修复rust路径的smartdns Makefile，支持完整的smartdns+webui功能
# cat > smartdns/Makefile <<EOF
# #
# # Copyright (c) 2018-2023 Nick Peng (pymumu@gmail.com)
# # This is free software, licensed under the GNU General Public License v3.
# #

# include \$(TOPDIR)/rules.mk

# PKG_NAME:=smartdns
# PKG_VERSION:=1.2025.46.2
# PKG_RELEASE:=3

# PKG_SOURCE_PROTO:=git
# PKG_SOURCE_URL:=https://www.github.com/pymumu/smartdns.git
# PKG_SOURCE_VERSION:=64fc9f20fba0e14cb118fe7f145557971cafd858
# PKG_MIRROR_HASH:=skip

# SMARTDNS_WEBUI_VERSION:=1.0.0
# SMAETDNS_WEBUI_SOURCE_PROTO:=git
# SMARTDNS_WEBUI_SOURCE_URL:=https://github.com/pymumu/smartdns-webui.git
# SMARTDNS_WEBUI_SOURCE_VERSION:=35cbf4a1940f5dd32670c69bd5cc02437ad073e7
# SMARTDNS_WEBUI_FILE:=smartdns-webui-\$(SMARTDNS_WEBUI_VERSION).tar.gz

# PKG_MAINTAINER:=Nick Peng <pymumu@gmail.com>
# PKG_LICENSE:=GPL-3.0-or-later
# PKG_LICENSE_FILES:=LICENSE

# PKG_BUILD_PARALLEL:=1

# # 修复rust路径以支持smartdns-ui编译
# PKG_BUILD_DEPENDS:=PACKAGE_smartdns-ui:rust/host

# include ../../../feeds/packages/lang/rust/rust-package.mk
# include \$(INCLUDE_DIR)/package.mk

# MAKE_VARS += VER=\$(PKG_VERSION) 
# MAKE_PATH:=src

# define Package/smartdns/default
#   SECTION:=net
#   CATEGORY:=Network
#   SUBMENU:=IP Addresses and Names
#   URL:=https://www.github.com/pymumu/smartdns/
# endef

# define Package/smartdns
#   \$(Package/smartdns/default)
#   TITLE:=smartdns server
#   DEPENDS:=+libpthread +libopenssl +libatomic
# endef

# define Package/smartdns/description
# SmartDNS is a local DNS server which accepts DNS query requests from local network clients,
# gets DNS query results from multiple upstream DNS servers concurrently, and returns the fastest IP to clients.
# Unlike dnsmasq's all-servers, smartdns returns the fastest IP, and encrypt DNS queries with DoT or DoH. 
# endef

# define Package/smartdns/conffiles
# /etc/config/smartdns
# /etc/smartdns/address.conf
# /etc/smartdns/blacklist-ip.conf
# /etc/smartdns/custom.conf
# /etc/smartdns/domain-block.list
# /etc/smartdns/domain-forwarding.list
# endef

# define Package/smartdns/install
# 	\$(INSTALL_DIR) \$(1)/usr/sbin \$(1)/etc/config \$(1)/etc/init.d 
# 	\$(INSTALL_DIR) \$(1)/etc/smartdns \$(1)/etc/smartdns/domain-set \$(1)/etc/smartdns/conf.d/
# 	\$(INSTALL_BIN) \$(PKG_BUILD_DIR)/src/smartdns \$(1)/usr/sbin/smartdns
# 	\$(INSTALL_BIN) \$(PKG_BUILD_DIR)/package/openwrt/files/etc/init.d/smartdns \$(1)/etc/init.d/smartdns
# 	\$(INSTALL_CONF) \$(PKG_BUILD_DIR)/package/openwrt/address.conf \$(1)/etc/smartdns/address.conf
# 	\$(INSTALL_CONF) \$(PKG_BUILD_DIR)/package/openwrt/blacklist-ip.conf \$(1)/etc/smartdns/blacklist-ip.conf
# 	\$(INSTALL_CONF) \$(PKG_BUILD_DIR)/package/openwrt/custom.conf \$(1)/etc/smartdns/custom.conf
# 	\$(INSTALL_CONF) \$(PKG_BUILD_DIR)/package/openwrt/files/etc/config/smartdns \$(1)/etc/config/smartdns
# endef

# define Package/smartdns-ui
#   \$(Package/smartdns/default)
#   TITLE:=smartdns dashboard
#   DEPENDS:=+smartdns \$(RUST_ARCH_DEPENDS)
# endef

# define Package/smartdns-ui/description
# A dashboard ui for smartdns server.
# endef

# define Package/smartdns-ui/conffiles
# /etc/config/smartdns
# endef

# define Package/smartdns-ui/install
# 	\$(INSTALL_DIR) \$(1)/usr/lib
# 	\$(INSTALL_DIR) \$(1)/etc/smartdns/conf.d/
# 	\$(INSTALL_DIR) \$(1)/usr/share/smartdns/wwwroot
# 	\$(INSTALL_BIN) \$(PKG_BUILD_DIR)/plugin/smartdns-ui/target/smartdns_ui.so \$(1)/usr/lib/smartdns_ui.so
# 	\$(CP) \$(PKG_BUILD_DIR)/smartdns-webui/out/* \$(1)/usr/share/smartdns/wwwroot
# endef

# define Build/Compile/smartdns-webui
# 	which npm || (echo "npm not found, please install npm first" && exit 1)
# 	npm install --prefix \$(PKG_BUILD_DIR)/smartdns-webui/
# 	npm run build --prefix \$(PKG_BUILD_DIR)/smartdns-webui/
# endef

# define Build/Compile/smartdns-ui
# 	cargo install --force --locked bindgen-cli
# 	CARGO_BUILD_ARGS="\$(if \$(strip \$(RUST_PKG_FEATURES)),--features "\$(strip \$(RUST_PKG_FEATURES))") --profile \$(CARGO_PKG_PROFILE)"
# 	+\$(CARGO_PKG_VARS) CARGO_BUILD_ARGS="\$(CARGO_BUILD_ARGS)" CC=\$(TARGET_CC) \\
# 	PATH="\$\$(PATH):\$(CARGO_HOME)/bin" \\
# 	make -C \$(PKG_BUILD_DIR)/plugin/smartdns-ui
# endef

# define Download/smartdns-webui
# 	FILE:=\$(SMARTDNS_WEBUI_FILE)
# 	PROTO:=\$(SMAETDNS_WEBUI_SOURCE_PROTO)
# 	URL:=\$(SMARTDNS_WEBUI_SOURCE_URL)
# 	MIRROR_HASH:=b3f4f73b746ee169708f6504c52b33d9bbeb7c269b731bd7de4f61d0ad212d74
# 	VERSION:=\$(SMARTDNS_WEBUI_SOURCE_VERSION)
# 	HASH:=\$(SMARTDNS_WEBUI_HASH)
# 	SUBDIR:=smartdns-webui
# endef
# \$(eval \$(call Download,smartdns-webui))

# ifdef CONFIG_PACKAGE_smartdns-ui
# define Build/Prepare
# 	\$(call Build/Prepare/Default)
# 	\$(TAR) -C \$(PKG_BUILD_DIR)/ -xf \$(DL_DIR)/\$(SMARTDNS_WEBUI_FILE)
# endef
# endif

# define Build/Compile
# 	\$(call Build/Compile/Default,smartdns)
# ifdef CONFIG_PACKAGE_smartdns-ui
# 	\$(call Build/Compile/smartdns-ui)
# 	\$(call Build/Compile/smartdns-webui)
# endif
# endef

# \$(eval \$(call BuildPackage,smartdns))
# \$(eval \$(call RustBinPackage,smartdns-ui))
# \$(eval \$(call BuildPackage,smartdns-ui))

# EOF

# # sed -i 's/$(PKG_BUILD_DIR)\/package\/openwrt/./g' smartdns/Makefile
# # sed -i 's/PKG_VERSION:=1.2025.46.2/PKG_VERSION:=$(PKG_VERSION)/g' smartdns/Makefile

# cat >> smartdns/custom.conf <<EOF

# speed-check-mode ping,tcp:80

# server 202.96.128.166 -group china
# server 202.96.134.133 -group china
# server 223.5.5.5 -group china
# server 223.6.6.6 -group china
# server 114.114.114.114 -group china
# server 114.114.115.115 -group china
# server 1.2.4.8 -group china
# server 210.2.4.8 -group china
# server 112.124.47.27 -group china
# server 114.215.126.16 -group china
# server 180.76.76.76 -group china
# server 119.29.29.29 -group china

# #请参照下列格式配置防污染DNS服务器
# #server-tls 8.8.4.4 -group gfwlist -exclude-default-group
# #server-tls 8.8.8.8 -group gfwlist -exclude-default-group
# #server-tls 1.1.1.1 -group gfwlist -exclude-default-group
# #server-tls 208.67.222.222 -group gfwlist -exclude-default-group
# #server-tls 208.67.220.220 -group gfwlist -exclude-default-group
# #server 127.0.0.1:7913 -group gfwlist -exclude-default-group

# conf-file /tmp/smartdns/blacklist_forward.conf
# conf-file /tmp/smartdns/gfwlist.conf
# conf-file /tmp/smartdns/whitelist_forward.conf
# conf-file /tmp/smartdns/forcelist_forward.conf

# EOF

# # (rm -fr ${ROOT}/ffeeds/packages/net/smartdns;mv smartdns ${ROOT}/feeds/packages/net/smartdns)

# # rm -fr luci-theme-argon
# rm -fr luci-theme-atmaterial
# rm -fr luci-app-serverchan
# rm -fr luci-app-koolproxyR
# rm -fr OpenAppFilter
# rm -fr luci-app-vssr
# rm -fr lua-maxminddb
# rm -fr luci-app-control-webrestriction
# rm -fr luci-app-control-weburl
# rm -fr luci-app-control-timewol
# # rm -fr luci-app-ssr-plus

# git clone --depth 1 https://github.com/tty228/luci-app-serverchan luci-app-serverchan
# git clone --depth 1 https://github.com/tofuliang/luci-app-koolproxyR luci-app-koolproxyR
# git clone --depth 1 https://github.com/destan19/OpenAppFilter OpenAppFilter
# git clone --depth 1 https://github.com/tofuliang/luci-app-vssr luci-app-vssr
# # svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash luci-app-openclash
# git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb lua-maxminddb
# # git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon luci-theme-argon
# # (cd luci-theme-argon;git remote set-branches origin '18.06';git fetch --depth 1 origin '18.06';git checkout '18.06')
# # (rm -fr ${ROOT}/feeds/luci/themes/luci-theme-argon;mv luci-theme-argon ${ROOT}/feeds/luci/themes/luci-theme-argon)
# # (rm -fr ${ROOT}/feeds/luci/applications/luci-app-serverchan;mv luci-app-serverchan ${ROOT}/feeds/luci/themes/luci-app-serverchan)
(
cd ~/lede/feeds/luci/applications;
git clone --branch openwrt-24.10 --depth 1 https://github.com/tofuliang/openwrt-package;
cp -fr openwrt-package/luci-app-control-webrestriction luci-app-control-webrestriction;
cp -fr openwrt-package/luci-app-accesscontrol luci-app-accesscontrol;
rm -fr openwrt-package;)

# (cd /tmp;git clone \
#   --depth 1  \
#   --filter=blob:none  \
#   --no-checkout \
#   https://github.com/KFERMercer/OpenWrt KFERMercer_OpenWrt;
# cd KFERMercer_OpenWrt;
# git checkout master -- package/lean/luci-app-usb-printer;
# )
# mv /tmp/KFERMercer_OpenWrt/package/lean/luci-app-usb-printer luci-app-usb-printer;

# # svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus luci-app-ssr-plus
# # svn co https://github.com/fw876/helloworld/trunk/tcping tcping
# # svn co https://github.com/fw876/helloworld/trunk/naiveproxy naiveproxy
# # pwd =>package/lean
# echo "\$(pwd) => $(pwd)"
# echo "cd ../.."
# cd ../..
# echo "\$(pwd) => $(pwd)"
# # (cd feeds/luci/applications/luci-app-unblockmusic; \
# # sed -i 's/"kuwo:kugou"/"kuwo:kugou:qq" -lv -ba -bu -sef/' root/etc/init.d/unblockmusic \
# # )
# (
#     cd ~/lede/feeds/packages/libs/rpcsvc-proto;
#     mkdir patches;
#     cp ~/lede/gettext-0.20.1.patch0 patches/gettext-0.20.1.patch;
# )
./scripts/feeds update -a -f
./scripts/feeds install -a
# ./scripts/feeds install -a -f -p helloworld

# ./scripts/feeds install -a
# ./scripts/feeds install -f smartdns
# ./scripts/feeds install -f luci-theme-argon
# ./scripts/feeds install -f luci-app-serverchan

echo "executing sed..."
# sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
# sed -i "s/'luci_password'/'luci_username'/g" feeds/luci/modules/luci-base/luasrc/view/sysauth.htm
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=[$(shell date +%Y%m%d)]-$(VERSION_DIST_SANITIZED)/g' include/image.mk
echo "done executing sed"