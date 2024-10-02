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

#解决依赖问题
sed -i "s/libpcre/libpcre2" package/feeds/telephony/freeswitch/Makefile

#替换mosdns
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

#修改ttyd登陆免输用户名
sed -i "s#/bin/login#/bin/login -f root#g" feeds/packages/utils/ttyd/files/ttyd.config

##自定义luci程序
# netdata
sed -i 's/system/status/g;s/10/90/g' feeds/luci/applications/luci-app-netdata/luasrc/controller/netdata.lua

# 解锁云音乐
sed -i 's/50/55/g;s/解除网易云音乐播放限制/解锁云音乐/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json


# FTP
sed -i 's/_("FTP Server")/_("FTP Server"), 5/' feeds/luci/applications/luci-app-vsftpd/luasrc/controller/vsftpd.lua

# Zerotier
sed -i 's/vpn/nas/g;s/90/30/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json


##修改菜单名称
#MultiWAN 管理器改成负载均衡
#sed -i 's/MultiWAN 管理器/负载均衡/g' `grep "MultiWAN 管理器" -rl ./feeds/luci/`

#UPnP IGD 和 PCP/NAT-PMP改成UPnP
#sed -i 's/UPnP IGD 和 PCP/NAT-PMP/UPnP/g' `grep "UPnP IGD 和 PCP/NAT-PMP" -rl ./feeds/luci/`

#带宽监控改成监控
#sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./feeds/luci/`

#网络存储改成服务器
sed -i 's/"网络存储"/"服务器"/g' `grep "网络存储" -rl ./feeds/luci/`
