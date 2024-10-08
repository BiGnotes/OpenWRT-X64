#!/bin/bash
# Copyright (c) 2022-2023 Curious <https://www.curious.host>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
# 
# https://github.com/Curious-r/OpenWrtBuildWorkflows
# Description: Automatically check OpenWrt source code update and build it. No additional keys are required.
#-------------------------------------------------------------------------------------------------------
#
#
# Patching is generally recommended.
# # Here's a template for patching:
#touch example.patch
#cat>example.patch<<EOF
#patch content
#EOF
#git apply example.patch

#修改ttyd登陆免输用户名
sed -i "s#/bin/login#/bin/login -f root#g" feeds/packages/utils/ttyd/files/ttyd.config

#关闭https登陆
sed -i 's/list listen_https/# list listen_https/' package/network/services/uhttpd/files/uhttpd.config

#删除自带netdata
rm -rf package/feeds/luci/luci-app-netdata/

#集成关机功能
#curl -fsSL  https://raw.githubusercontent.com/sirpdboy/other/master/patch/poweroff/poweroff.htm > feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_system/poweroff.htm 
#curl -fsSL  https://raw.githubusercontent.com/sirpdboy/other/master/patch/poweroff/system.lua > feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua

##自定义luci程序
# 任务设置
sed -i '/entry({"admin", "control"}, firstchild(), "Control", 44).dependent = false/d' feeds/big/luci-app-autotimeset/luasrc/controller/autotimeset.lua
sed -i 's/"admin", "control"/"admin", "system"/g' feeds/big/luci-app-autotimeset/luasrc/controller/autotimeset.lua
sed -i 's/"admin","control"/"admin", "system"/g' feeds/big/luci-app-autotimeset/luasrc/controller/autotimeset.lua
sed -i 's/, 20/, 62/' feeds/big/luci-app-autotimeset/luasrc/controller/autotimeset.lua

# luci-app-appfilter顺序
sed -i 's/"services"/"control"/g' feeds/big/luci-app-oaf/luasrc/controller/appfilter.lua
sed -i 's/2\([0-5]\)/8\1/g' feeds/big/luci-app-oaf/luasrc/controller/appfilter.lua

# Adguard Home
sed -i 's/page.order = 10/page.order = 5/' feeds/big/luci-app-adguardhome/luasrc/controller/AdGuardHome.lua

# PassWall
sed -i 's/_("Pass Wall"), -1/_("Pass Wall"), 10/' feeds/big/luci-app-passwall/luasrc/controller/passwall.lua
sed -i 's/nil, -1/nil, 10/' feeds/big/luci-app-passwall/luasrc/controller/passwall.lua

# OpenClash
sed -i 's/_("OpenClash"), 50/_("OpenClash"), 15/' feeds/big/luci-app-openclash/luasrc/controller/openclash.lua

# MosDNS
sed -i 's/_("MosDNS"), 30/_("MosDNS"), 20/' feeds/luci/applications/luci-app-mosdns/luasrc/controller/mosdns.lua

# SmartDNS
sed -i 's/_("SmartDNS"), 60/_("SmartDNS"), 25/' feeds/luci/applications/luci-app-smartdns/luasrc/controller/smartdns.lua

# udpxy
sed -i 's/_("udpxy")/_("udpxy"), 30/' feeds/luci/applications/luci-app-udpxy/luasrc/controller/udpxy.lua

# UPnP
sed -i 's/_("UPnP")/_("UPnP"), 35/' feeds/luci/applications/luci-app-upnp/luasrc/controller/upnp.lua

# WOL Plus
sed -i 's/_("wolplus"), 95/_("wolplus"), 40/' feeds/big/luci-app-wolplus/luasrc/controller/wolplus.lua

# MWAN3 Helper
sed -i 's/_("MWAN3 Helper"), 300/_("MWAN3 Helper"), 45/' feeds/luci/applications/luci-app-mwan3helper/luasrc/controller/mwan3helper.lua

# 全能推送
sed -i 's/_("全能推送"), 30/_("全能推送"), 50/' feeds/luci/applications/luci-app-pushbot/luasrc/controller/pushbot.lua

# 解锁云音乐
sed -i 's/_("Unblock Netease Music"), 50/_("Unblock Netease Music"), 55/' feeds/luci/applications/luci-app-unblockmusic/luasrc/controller/unblockmusic.lua

# FTP
sed -i 's/_("FTP Server")/_("FTP Server"), 5/' feeds/luci/applications/luci-app-vsftpd/luasrc/controller/vsftpd.lua

# Frps
sed -i 's/"services"/"nas"/g' feeds/luci/applications/luci-app-frps/luasrc/controller/frps.lua
sed -i 's/_("Frps"), 99/_("Frps"), 10/' feeds/luci/applications/luci-app-frps/luasrc/controller/frps.lua

# Frps
sed -i 's/"services"/"nas"/g' feeds/luci/applications/luci-app-frpc/luasrc/controller/frp.lua
sed -i 's/_("Frp Setting"), 100/_("Frp Setting"), 15/' feeds/luci/applications/luci-app-frpc/luasrc/controller/frp.lua

# Lucky
sed -i 's/"services"/"nas"/g' feeds/big/luci-app-lucky/luci-app-lucky/luasrc/controller/lucky.lua
sed -i 's/_("Lucky"), 57/_("Lucky"), 20/' feeds/big/luci-app-lucky/luci-app-lucky/luasrc/controller/lucky.lua

# KMS服务器
sed -i 's/"services"/"nas"/g' feeds/luci/applications/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua
sed -i 's/_("KMS Server"), 100/_("KMS Server"), 25/' feeds/luci/applications/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua

# Zerotier
sed -i '/entry({"admin", "vpn"}, firstchild(), "VPN", 45).dependent = false/d' feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua
sed -i 's/"vpn"/"nas"/g' feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua
sed -i 's/_("ZeroTier"), 99/_("ZeroTier"), 30/' feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua

##修改菜单名称

#带宽监控改成监控
#sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./feeds/luci/`

#网络存储改成服务器
sed -i 's/"网络存储"/"服务器"/g' `grep "网络存储" -rl ./feeds/luci/`

