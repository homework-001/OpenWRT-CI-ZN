# 修改默认IP & 固件名称
sed -i 's/192.168.1.1/192.168.0.1/g' package/base-files/files/bin/config_generate
sed -i "s/hostname='.*'/hostname='losky'/g" package/base-files/files/bin/config_generate

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 移除要替换的包
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Alist & AdGuardHome & WolPlus & AriaNg & 集客无线AC控制器 & Lucky
git_sparse_clone main https://github.com/kenzok8/small-package adguardhome luci-app-adguardhome
git clone --depth=1 https://github.com/lwb1978/openwrt-gecoosac package/openwrt-gecoosac
git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/luci-app-lucky

git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash

# Theme
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# MosDNS
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns


git clone --depth=1 https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
git clone --depth=1 https://github.com/sirpdboy/luci-app-partexp.git package/luci-app-partexp
git clone --depth=1 https://github.com/animegasan/luci-app-wolplus.git package/luci-app-wolplus
git clone --depth=1 https://github.com/animegasan/luci-app-wolplus.git package/luci-app-wolplus
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

./scripts/feeds update -a
./scripts/feeds install -a
