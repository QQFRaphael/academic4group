#!/bin/bash

case="BJRS"

commands=("cmarad2dsr -params cmarad2dsr_xldai_realtime.params -instance ${case}" \
"JamesD -params JamesD_xldai_SA.dealias -instance ${case}" \
"ApRemoval -params ApRemoval_xldai.${case} -instance ${case}" \
"Dsr2Vol -params Dsr2Vol_xldai_SA.raw -instance ${case}raw" \
"Dsr2Vol -params Dsr2Vol_xldai_SA.polarPPI2tilt -instance ${case}polarPPI2tilt" \
"Dsr2Vol -params Dsr2Vol_xldai_SA.cart -instance ${case}cart" \
"Dsr2Vol -params Dsr2Vol_xldai_SA.ppiFullVol -instance ${case}ppiFullVol" \
"Dsr2Vol -params Dsr2Vol_xldai_SA.polarPPI2tiltAp -instance ${case}polarPPI2tiltAp" \
"Dsr2Vol -params Dsr2Vol_xldai_SA.cartAp -instance ${case}cartAp" \
"Dsr2Vol -params Dsr2Vol_xldai_SA.ppiFullVolAp -instance ${case}ppiFullVolAp" \
"Dsr2Vol -params Dsr2Vol_xldai_SA.halfDegreePpi500m -instance ${case}halfDegreePpi500m" \
"vadAnalysis -params vadAnalysis_xldai.JamesD -instance ${case}" \
"ClutterRemove -params ClutterRemove_xldai.polar -instance ${case}polar" \
"ClutterRemove -params ClutterRemove_xldai.ppi1km -instance ${case}ppi1km" \
"ClutterRemove -params ClutterRemove_xldai.cart -instance ${case}cart" \
"ClutterRemove -params ClutterRemove_xldai.halfDegreePpi500m -instance ${case}halfDegreePpi500m")

for ((i = 0; i < ${#commands[@]}; i ++))
do
    cc=$(echo ${commands[${i}]})
    ids=`ps -ef | grep "$cc" | awk '{if ($3==1) print $2}'`
    for id in $ids
    do
        if [ -n "${id}" ]; then
            kill -9 ${id}
        fi
    done
echo "kill ${commands[${i}]}"
done

logfilter=`ps -ef | grep "LogFilter" | awk '{if ($3==1) print $2}'`
for id in ${logfilter}
do
    kill -9 ${id}
done