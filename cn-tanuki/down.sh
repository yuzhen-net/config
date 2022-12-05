#!/bin/bash
set -x
kill $(cat /var/run/babeld.pid)


ip link del int-cn-pek-4
ip link del int-cn-csx-4
