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

ip_hk_hkg_4=$(resolveip hk-hkg.nodes.yuzhen.network)
ip_us_nyc_4=$(resolveip us-nyc.nodes.yuzhen.network)
ip_au_nsw_4=$(resolveip au-nsw.nodes.yuzhen.network)
ip_uk_lon_4=$(resolveip uk-lon.nodes.yuzhen.network)
ip_cn_pek_4=$(resolveip cn-pek.nodes.yuzhen.network)
ip_nl_ams_4=$(resolveip nl-ams.nodes.yuzhen.network)
ip_cn_csx_4=$(resolveip cn-csx.nodes.yuzhen.network)
ip_us_sea_4=$(resolveip us-sea.nodes.yuzhen.network)


if get_ip_down "fe80::2399:1" "int-hk-hkg-4"; then
    update_wg_peer int-hk-hkg-4 "xE7n63bfDpppBBlm19eung9ZBoXdMDCMbIA81gezhBY=" "$ip_hk_hkg_4:18000" "igp_tunnels/int-hk-hkg-4.conf"
fi
if get_ip_down "fe80::2399:2" "int-us-nyc-4"; then
    update_wg_peer int-us-nyc-4 "qZcGPPoSDfNhUNhTUgllJ901cN7BnSm19esv/rO2qzQ=" "$ip_us_nyc_4:18001" "igp_tunnels/int-us-nyc-4.conf"
fi
if get_ip_down "fe80::2399:3" "int-au-nsw-4"; then
    update_wg_peer int-au-nsw-4 "LiDzHat2kywF2qqn7X5giRIabNMsF5STFQ9KCXGfeFg=" "$ip_au_nsw_4:18002" "igp_tunnels/int-au-nsw-4.conf"
fi
if get_ip_down "fe80::2399:4" "int-uk-lon-4"; then
    update_wg_peer int-uk-lon-4 "MnAoon9Gsh/Vsbl7P0SRoGU290FMTugschWBmhNXjRU=" "$ip_uk_lon_4:18003" "igp_tunnels/int-uk-lon-4.conf"
fi
if get_ip_down "fe80::2399:5" "int-cn-pek-4"; then
    update_wg_peer int-cn-pek-4 "rKY7I17fjuANn5+rfSnFLm8EpsRMFNj1nz/AjWA6vwc=" "$ip_cn_pek_4:18004" "igp_tunnels/int-cn-pek-4.conf"
fi
if get_ip_down "fe80::2399:7" "int-nl-ams-4"; then
    update_wg_peer int-nl-ams-4 "DkbI8OjJW33OjPpYZa8iG1718vfbKVZdHMrB+0RyT2k=" "$ip_nl_ams_4:18005" "igp_tunnels/int-nl-ams-4.conf"
fi
if get_ip_down "fe80::2399:8" "int-cn-csx-4"; then
    update_wg_peer int-cn-csx-4 "igenKeX0BhyLY/VGlP7ZmbGUQsIYcjsnXgcIVSnKDTg=" "$ip_cn_csx_4:18006" "igp_tunnels/int-cn-csx-4.conf"
fi
if get_ip_down "fe80::2399:9" "int-us-sea-4"; then
    update_wg_peer int-us-sea-4 "arG1USG6tq16NucquEQcClFu3nwLbC3ZVJeqFI6UOjc=" "$ip_us_sea_4:18007" "igp_tunnels/int-us-sea-4.conf"
fi


