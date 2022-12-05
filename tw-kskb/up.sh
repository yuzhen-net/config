#!/bin/bash

resolveip()
{
  : ${1:?Usage: resolve name}
  (
    PATH=$PATH:/usr/bin
    lookupresult=$(getent ahostsv4 "$1")
    if [ $? -eq 0 ]; then
        resultaddr=$(echo $lookupresult | head -n 1 | awk '{print $1}')
        echo $resultaddr
        return 0
    fi
    lookupresult=$(getent ahostsv6 $1)
    if [ $? -eq 0 ]; then
        resultaddr=$(echo $lookupresult | head -n 1 | awk '{print $1}')
        echo "[$resultaddr]"
        return 0
    fi
    echo "0.0.0.0"
    return 127
  )
}
set -x
ip route add 172.23.33.198/32 dev lo proto 114 table 114 scope link
ip route add 2a12:dd47:83e0:6::1/128 dev lo proto 114 table 114 scope link

cp bird/igp_metric.zero.conf bird/igp_metric.conf

ip_hk_hkg_4=$(resolveip hk-hkg.nodes.yuzhen.network)
ip link add dev int-hk-hkg-4 type wireguard
wg setconf int-hk-hkg-4 igp_tunnels/int-hk-hkg-4.conf
ip link set int-hk-hkg-4 up
ip link set mtu 1440 dev int-hk-hkg-4
ip addr add 172.23.33.198/32 dev int-hk-hkg-4
ip addr add 2a12:dd47:83e0:6::1/128 dev int-hk-hkg-4
ip addr add fe80::2399:6/64 dev int-hk-hkg-4 scope link

ip_us_nyc_4=$(resolveip us-nyc.nodes.yuzhen.network)
ip link add dev int-us-nyc-4 type wireguard
wg setconf int-us-nyc-4 igp_tunnels/int-us-nyc-4.conf
ip link set int-us-nyc-4 up
ip link set mtu 1440 dev int-us-nyc-4
ip addr add 172.23.33.198/32 dev int-us-nyc-4
ip addr add 2a12:dd47:83e0:6::1/128 dev int-us-nyc-4
ip addr add fe80::2399:6/64 dev int-us-nyc-4 scope link

ip_au_nsw_4=$(resolveip au-nsw.nodes.yuzhen.network)
ip link add dev int-au-nsw-4 type wireguard
wg setconf int-au-nsw-4 igp_tunnels/int-au-nsw-4.conf
ip link set int-au-nsw-4 up
ip link set mtu 1440 dev int-au-nsw-4
ip addr add 172.23.33.198/32 dev int-au-nsw-4
ip addr add 2a12:dd47:83e0:6::1/128 dev int-au-nsw-4
ip addr add fe80::2399:6/64 dev int-au-nsw-4 scope link

ip_uk_lon_4=$(resolveip uk-lon.nodes.yuzhen.network)
ip link add dev int-uk-lon-4 type wireguard
wg setconf int-uk-lon-4 igp_tunnels/int-uk-lon-4.conf
ip link set int-uk-lon-4 up
ip link set mtu 1440 dev int-uk-lon-4
ip addr add 172.23.33.198/32 dev int-uk-lon-4
ip addr add 2a12:dd47:83e0:6::1/128 dev int-uk-lon-4
ip addr add fe80::2399:6/64 dev int-uk-lon-4 scope link

ip_cn_pek_4=$(resolveip cn-pek.nodes.yuzhen.network)
ip link add dev int-cn-pek-4 type wireguard
wg setconf int-cn-pek-4 igp_tunnels/int-cn-pek-4.conf
ip link set int-cn-pek-4 up
ip link set mtu 1440 dev int-cn-pek-4
ip addr add 172.23.33.198/32 dev int-cn-pek-4
ip addr add 2a12:dd47:83e0:6::1/128 dev int-cn-pek-4
ip addr add fe80::2399:6/64 dev int-cn-pek-4 scope link

ip_nl_ams_4=$(resolveip nl-ams.nodes.yuzhen.network)
ip link add dev int-nl-ams-4 type wireguard
wg setconf int-nl-ams-4 igp_tunnels/int-nl-ams-4.conf
ip link set int-nl-ams-4 up
ip link set mtu 1440 dev int-nl-ams-4
ip addr add 172.23.33.198/32 dev int-nl-ams-4
ip addr add 2a12:dd47:83e0:6::1/128 dev int-nl-ams-4
ip addr add fe80::2399:6/64 dev int-nl-ams-4 scope link

ip_cn_csx_4=$(resolveip cn-csx.nodes.yuzhen.network)
ip link add dev int-cn-csx-4 type wireguard
wg setconf int-cn-csx-4 igp_tunnels/int-cn-csx-4.conf
ip link set int-cn-csx-4 up
ip link set mtu 1440 dev int-cn-csx-4
ip addr add 172.23.33.198/32 dev int-cn-csx-4
ip addr add 2a12:dd47:83e0:6::1/128 dev int-cn-csx-4
ip addr add fe80::2399:6/64 dev int-cn-csx-4 scope link

ip_us_sea_4=$(resolveip us-sea.nodes.yuzhen.network)
ip link add dev int-us-sea-4 type wireguard
wg setconf int-us-sea-4 igp_tunnels/int-us-sea-4.conf
ip link set int-us-sea-4 up
ip link set mtu 1440 dev int-us-sea-4
ip addr add 172.23.33.198/32 dev int-us-sea-4
ip addr add 2a12:dd47:83e0:6::1/128 dev int-us-sea-4
ip addr add fe80::2399:6/64 dev int-us-sea-4 scope link


mkdir -p /var/run/babeld
rm /var/run/babeld/rw.sock || true
rm /var/run/babeld/ro.sock || true
babeld -D -I /var/run/babeld.pid -S /var/lib/babeld/state -c babeld.conf
