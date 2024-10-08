#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

#sed -i 's/192.168.123.5/192.168.50.5/g' package/base-files/files/bin/config_generate



mkdir -p files/etc/config


tee files/etc/config/wireless <<EOF


config wifi-device 'radio0'
	option type 'mac80211'
	option path 'platform/soc@0/c000000.wifi'
	option channel '149'
	option band '5g'
	option htmode 'HE80'
	option cell_density '0'
	option txpower '21'
	option mu_beamformer '1'
	option country 'CN'

config wifi-iface 'default_radio0'
	option device 'radio0'
	option network 'lan'
	option mode 'ap'
	option ssid 'LibWrt-default-5g'
	option encryption 'sae'
	option key '1234567890'
	option ocv '0'

config wifi-device 'radio1'
	option type 'mac80211'
	option path 'platform/soc@0/c000000.wifi+1'
	option channel '1'
	option band '2g'
	option htmode 'HE20'
	option disabled '1'

config wifi-iface 'default_radio1'
	option device 'radio1'
	option network 'lan'
	option mode 'ap'
	option ssid 'LibWrt'
	option encryption 'none'
	option disabled '1'



EOF


tee files/etc/config/network <<EOF



config interface 'loopback'
	option device 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'

config device
	option name 'br-lan'
	option type 'bridge'
	list ports 'eth0'
	list ports 'eth1'
	list ports 'eth2'

config interface 'lan'
	option device 'br-lan'
	option proto 'static'
	option ipaddr '192.168.123.23'
	option netmask '255.255.255.0'
	option ip6assign '60'
	list dns '223.5.5.5'
	list dns '223.6.6.6'
	option ip6ifaceid 'eui64'

config interface 'wan'
	option device 'eth3'
	option proto 'static'
	option ipaddr '192.168.1.228'
	option netmask '255.255.255.0'
	option gateway '192.168.1.1'
	list dns '223.5.5.5'
	list dns '223.6.6.6'

config interface 'wan6'
	option device '@wan'
	option proto 'dhcpv6'
	option reqaddress 'try'
	option reqprefix 'auto'





EOF




tee files/etc/config/dhcp <<EOF



  
config dnsmasq
	option domainneeded '1'
	option localise_queries '1'
	option rebind_protection '1'
	option rebind_localhost '1'
	option local '/lan/'
	option domain 'lan'
	option expandhosts '1'
	option cachesize '1000'
	option authoritative '1'
	option readethers '1'
	option leasefile '/tmp/dhcp.leases'
	option localservice '1'
	option ednspacket_max '1232'
	list server '223.5.5.5'
	list server '223.6.6.6'
	option localuse '1'

config dhcp 'lan'
	option interface 'lan'
	option start '100'
	option limit '100'
	option leasetime '12h'
	option dhcpv4 'server'
	option ra 'server'
	option dns_service '0'
	list ra_flags 'other-config'
	option max_preferred_lifetime '2700'
	option max_valid_lifetime '5400'

config dhcp 'wan'
	option interface 'wan'
	option ignore '1'
	option start '100'
	option limit '150'
	option leasetime '12h'

config odhcpd 'odhcpd'
	option maindhcp '0'
	option leasefile '/tmp/hosts/odhcpd'
	option leasetrigger '/usr/sbin/odhcpd-update'
	option loglevel '4'







EOF


