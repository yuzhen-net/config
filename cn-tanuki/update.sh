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

get_wg_peer_down () {
    #1:name, 2:peer key, 3:peer endpoint, 4:confpath
    current_time=$(date +%s)
    last_handshake=$(wg show "$1" latest-handshakes | grep "$2" | awk "{print \$2}")
    if [ -z "$last_handshake" ]; then
        last_handshake=0
        wg setconf "$1" "$4"
    fi
    last_to_now=$(("$current_time"-"$last_handshake"))
    if [ "$last_to_now" -gt "180" ]; then
        return 0 #success, means down
    fi
        return 1 #fail, means up
}

update_wg_peer() {
    if get_wg_peer_down "$1" "$2" "$3" "$4"; then
        wg set "$1" listen-port "5$(head /dev/urandom | tr -dc "0123456789" | head -c4)"
        wg set "$1" peer "$2" endpoint "$3"
    fi
}

get_ip_down () {
    #1:ip 2:ifname
    if ! ping -c 1 -W 3 "$1" -I "$2"
    then
        return 0 #success, means down
    fi
    return 1 # fail. means up
}

ip_cn_pek_4=$(resolveip cn-pek.nodes.yuzhen.network)
ip_cn_csx_4=$(resolveip cn-csx.nodes.yuzhen.network)


if get_ip_down "fe80::2399:5" "int-cn-pek-4"; then
    update_wg_peer int-cn-pek-4 "rKY7I17fjuANn5+rfSnFLm8EpsRMFNj1nz/AjWA6vwc=" "$ip_cn_pek_4:18005" "igp_tunnels/int-cn-pek-4.conf"
fi
if get_ip_down "fe80::2399:8" "int-cn-csx-4"; then
    update_wg_peer int-cn-csx-4 "igenKeX0BhyLY/VGlP7ZmbGUQsIYcjsnXgcIVSnKDTg=" "$ip_cn_csx_4:18007" "igp_tunnels/int-cn-csx-4.conf"
fi


