#!/usr/bin/env bash

export build_profile=$1
export spec=$2
export ReleaseVersion="$(git rev-parse --short HEAD)-$(date +%Y.%m.%d)"

rm -f ./.config*
[ -f ${build_profile}.config ] && cp ${build_profile}.config ./.config
sed -i 's/^[ \t]*//g' ./.config
echo -e 'CONFIG_DEVEL=y\nCONFIG_CCACHE=y' >> ./.config
[ -d dl ] && cp xxd-1.10.tar.gz dl || true
make defconfig

upstream_sha="$(git rev-parse --short HEAD)"
upstream_ref="${UPSTREAM_TAG:-}"
if [ -z "$upstream_ref" ]; then
    upstream_ref="$(git describe --tags --exact-match HEAD 2>/dev/null || true)"
fi
if [ -z "$upstream_ref" ]; then
    upstream_ref="$(git describe --tags --abbrev=0 2>/dev/null || true)"
fi
build_stamp="$(date +%Y.%m.%d)"
version_code="${upstream_sha} ${build_stamp}"
if [ -n "$upstream_ref" ]; then
    version_code="${version_code} [${upstream_ref}]"
fi
if [ -n "$spec" ]; then
    version_code="${version_code} ${spec}"
fi
sed -i '/^CONFIG_VERSION_CODE=/d' .config
echo "CONFIG_VERSION_CODE=\"${version_code}\"" >> .config

make download -j8

# (cd feeds/luci;git reset --hard;patch -p1 < ../../luci.patch0)
# (cd feeds/luci/applications/luci-app-accesscontrol && patch -p1 < ../../../../luci-app-accesscontrol.patch0)

# patch -p1 < autocore.patch0

# [ -f package/lean/autocore/files/arm/index.htm ] && sed -i "s/<%=pcdata(ver.distversion)%>/<%=pcdata(ver.distversion)%> [$ReleaseVersion]/g" package/lean/autocore/files/arm/index.htm
# [ -f package/lean/autocore/files/x86/index.htm ] && sed -i "s/<%=pcdata(ver.distversion)%>/<%=pcdata(ver.distversion)%> [$ReleaseVersion]/g" package/lean/autocore/files/x86/index.htm
# (cd feeds/luci;[ -f modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm ] && sed -i "s/<%=pcdata(ver.distversion)%>/<%=pcdata(ver.distversion)%> [$ReleaseVersion]/g" modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm)

[ -f ${build_profile}_files.txz ] && tar xf ${build_profile}_files.txz || true
if [ "$spec" != "" ];then
    git checkout include/image.mk
    sed -i "s/^IMG_PREFIX:=.*/IMG_PREFIX:=[\$(shell date +%Y%m%d)]-\$(VERSION_DIST_SANITIZED)-${spec}-\$(IMG_PREFIX_VERNUM)\$(IMG_PREFIX_VERCODE)\$(IMG_PREFIX_EXTRA)\$(BOARD)-\$(SUBTARGET)/" include/image.mk
fi