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
# This script will run before feeds update, something you want to do at that moment should be written here.
# A common function of this script is to modify the cloned OpenWrt source code. 
#
# For instance, you can edit the feeds.conf.default to induct packages you need.
# This is followed by some editing examples.
# # Clear the feeds.conf.default and append the feed sources you need one by one:
#cat /dev/null > a.txt
#echo 'src-git-full packages https://git.openwrt.org/feed/packages.git;openwrt-22.03' >> feeds.conf.default
#echo 'src-git-full luci https://git.openwrt.org/project/luci.git;openwrt-22.03' >> feeds.conf.default
#echo 'src-git-full routing https://git.openwrt.org/feed/routing.git;openwrt-22.03' >> feeds.conf.default
#echo 'src-git-full telephony https://git.openwrt.org/feed/telephony.git;openwrt-22.03' >> feeds.conf.default
# # Replace a feed source with what you want:
#sed '/feeds-name/'d feeds.conf.default
#echo 'method feed-name path/URL' >> feeds.conf.default
# # Uncomment a feed source:
#sed -i 's/^#\(.*feed-name\)/\1/' feeds.conf.default
# # Replace src-git-full with src-git to reduce the depth of cloning:
#sed -i 's/src-git-full/src-git/g' feeds.conf.default
#
# You can also modify the source code by patching.
# # Here's a template for patching:
#touch example.patch
#cat>example.patch<<EOF
#patch content
#EOF
#git apply example.patch

#增加自己的仓库
echo 'src-git imp https://github.com/BiGnotes/im-package.git' >> feeds.conf.default

#修改ip地址
sed -i 's/192.168.1.1/192.168.1.10/g' package/base-files/files/bin/config_generate

#修改主机名
#sed -i '/commit system/i\set system.@system[0].hostname='Super_Router'' package/emortal/default-settings/files/99-default-settings-chinese

#更换默认源地址
sed -i 's/mirrors.vsean.net/mirrors.nju.edu.cn/g' package/emortal/default-settings/files/99-default-settings-chinese

#添加kiddin9仓库
echo '#src/gz kiddin9 https://dl.openwrt.ai/23.05/packages/x86_64/kiddin9/' >> package/system/opkg/files/customfeeds.conf

#修改编译者信息（日期）
#sed -i 's/%D %V %C/Eugene build $(TZ=UTC-8 date '+%Y.%m.%d') @ Immortalwrt/g' package/base-files/files/etc/openwrt_release

