#!/bin/bash

# 关闭https
sed -i "/list listen_https '0.0.0.0:443'/d" package/network/services/uhttpd/files/uhttpd.config
sed -i "/list listen_https '[::]:443'/d" package/network/services/uhttpd/files/uhttpd.config
