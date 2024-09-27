#!/bin/bash

# 关闭https
sed -i "/list listen_https '0.0.0.0:443'/d" /etc/config/uhttpd
sed -i "/list listen_https '[::]:443'/d" /etc/config/uhttpd
