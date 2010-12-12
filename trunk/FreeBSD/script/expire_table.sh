#!/bin/sh

#
# in pf.conf:
# table <deny> persist { }
# ...
# block in log quick inet from <deny> probability 80%
# ...
# pass  in log on $ext_if inet proto tcp from any to ($ext_if) port ssh \
# 	flags S/SA synproxy state \
#		(max-src-conn 50, max-src-conn-rate 5/3, overload <deny> flush global) \
#			queue(q_epri q_eack)
#

SHOW=$(/sbin/pfctl -v -tdeny -Tshow)
EXPIRE=$(/usr/local/sbin/expiretable -v -t 3600 deny)

if [ $(echo ${EXPIRE} | egrep 'deny.*deleted' | wc -l) -gt 0 ]; then
    printf "${SHOW}\n${EXPIRE}\n"
    /sbin/pfctl -v -tdeny -Tshow
fi
