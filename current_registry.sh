#!/bin/bash
ENDPOINT=`oc project | awk '{print $6}'| cut -d '"' -f 2 2>/dev/null | tail -n1`
#echo endpoint  $ENDPOINT
oc_registry=`sh ./login_oc.sh ${ENDPOINT} 2>/dev/null|tail -n1 |rev|awk '{print $1}'|rev|tail -n1 2>/dev/null`
echo $oc_registry
