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

#定义路径变量，缩短代码
path1="feeds/luci/applications"
path2="root/usr/share/luci/menu.d"

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

# Adguard Home
sed -i 's/10/5/g' feeds/imp/luci-app-adguardhome/luasrc/controller/AdGuardHome.lua

# PassWall
sed -i 's/("Pass Wall"), -1/("Pass Wall"), 10/' feeds/luci/applications/luci-app-passwall/luasrc/controller/passwall.lua
sed -i 's/nil, -1/nil, 10/' feeds/luci/applications/luci-app-passwall/luasrc/controller/passwall.lua

# OpenClash
sed -i 's/("OpenClash"), 50/("OpenClash"), 15/' feeds/luci/applications/luci-app-openclash/luasrc/controller/openclash.lua
# MosDNS
sed -i 's/30/20/g' package/mosdns/luci-app-mosdns/root/usr/share/luci/menu.d/luci-app-mosdns.json
# SmartDNS
jq '.["admin/services/smartdns"].order = 25' $path1/luci-app-smartdns/$path2/luci-app-smartdns.json > ~/tmp.json && mv ~/tmp.json $path1/luci-app-smartdns/$path2/luci-app-smartdns.json

# udpxy
jq '.["admin/services/udpxy"].order = 25' $path1/luci-app-udpxy/$path2/luci-app-udpxy.json > ~/tmp.json && mv ~/tmp.json $path1/luci-app-udpxy/$path2/luci-app-udpxy.json

# UPnP
jq '.["admin/services/upnp"].order = 25' $path1/luci-app-upnp/$path2/luci-app-upnp.json > ~/tmp.json && mv ~/tmp.json $path1/luci-app-upnp/$path2/luci-app-upnp.json

# WOL Plus
sed -i 's/95/40/' feeds/imp/luci-app-wolplus/luasrc/controller/wolplus.lua

# 微信推送
sed -i '0,/30/s/30/50/' feeds/luci/applications/luci-app-wechatpush/root/usr/share/luci/menu.d/luci-app-wechatpush.json

# 解锁云音乐
sed -i 's/50/55/g;s/解除网易云音乐播放限制/解锁云音乐/g' feeds/luci/applications/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# 任务设置
sed -i '/entry({"admin", "control"}, firstchild(), "Control", 44).dependent = false/d' feeds/imp/luci-app-autotimeset/luasrc/controller/autotimeset.lua
sed -i 's/"admin", "control"/"admin", "system"/g' feeds/imp/luci-app-autotimeset/luasrc/controller/autotimeset.lua
sed -i 's/"admin","control"/"admin", "system"/g' feeds/imp/luci-app-autotimeset/luasrc/controller/autotimeset.lua
sed -i 's/, 20/, 62/' feeds/imp/luci-app-autotimeset/luasrc/controller/autotimeset.lua

# luci-app-appfilter
sed -i 's/"services"/"control"/g' feeds/luci/applications/luci-app-appfilter/luasrc/controller/appfilter.lua
sed -i 's/2\([0-5]\)/8\1/g' feeds/luci/applications/luci-app-appfilter/luasrc/controller/appfilter.lua

# FTP
sed -i 's/_("FTP Server")/_("FTP Server"), 5/' feeds/luci/applications/luci-app-vsftpd/luasrc/controller/vsftpd.lua

# Frpc
jq '.["admin/services/frpc"].order = 10' $path1/luci-app-frpc/$path2/luci-app-frpc.json > ~/tmp.json && mv ~/tmp.json $path1/luci-app-frpc/$path2/luci-app-frpc.json
sed -i 's/services/nas/g' $path1/luci-app-frpc/$path2/luci-app-frpc.json

# Frps
jq '.["admin/services/frps"].order = 15' $path1/luci-app-frps/$path2/luci-app-frps.json > ~/tmp.json && mv ~/tmp.json $path1/luci-app-frps/$path2/luci-app-frps.json
sed -i 's/services/nas/g' $path1/luci-app-frps/$path2/luci-app-frps.json

# Lucky
sed -i 's/"services"/"nas"/g' feeds/imp/luci-app-lucky/luasrc/controller/lucky.lua
sed -i 's/_("Lucky"), 57/_("Lucky"), 20/' feeds/imp/luci-app-lucky/luasrc/controller/lucky.lua

# KMS服务器
sed -i 's/"services"/"nas"/g' feeds/luci/applications/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua
sed -i 's/_("KMS Server"), 100/_("KMS Server"), 25/' feeds/luci/applications/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua

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
