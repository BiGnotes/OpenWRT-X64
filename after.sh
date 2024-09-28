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
sed -i "/^list listen_https 0.0.0.0:443/s/^/#/" package/network/services/uhttpd/files/uhttpd.config
sed -i "/^list listen_https	[::]:443/s/^/#/" package/network/services/uhttpd/files/uhttpd.config

#删除自带netdata
rm -rf package/feeds/luci/luci-app-netdata/
