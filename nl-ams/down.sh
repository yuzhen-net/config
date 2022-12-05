#!/bin/bash
set -x
kill $(cat /var/run/babeld.pid)


ip link del int-hk-hkg-4
ip link del int-us-nyc-4
ip link del int-au-nsw-4
ip link del int-uk-lon-4
ip link del int-cn-pek-4
ip link del int-tw-kskb-4
ip link del int-cn-csx-4
ip link del int-us-sea-4
ip link del int-cn-hgh-4
