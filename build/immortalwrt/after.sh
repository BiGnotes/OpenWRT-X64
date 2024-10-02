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



##修改菜单名称

#带宽监控改成监控
#sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./feeds/luci/`

#网络存储改成服务器
sed -i 's/"网络存储"/"服务器"/g' `grep "网络存储" -rl ./feeds/luci/`
