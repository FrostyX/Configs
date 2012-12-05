#!/bin/bash
# by Paul Colby (http://colby.id.au), no rights reserved ;)
# http://code.google.com/p/bashets/source/browse/trunk/userscripts/cpu.sh?r=13
# https://bbs.archlinux.org/viewtopic.php?id=75937
CORE=$1
TMP1="/tmp/cpuusage.total$CORE"
TMP2="/tmp/cpuusage.idle$CORE"

if [ ! -s "$TMP1" ]; then
        touch "$TMP1"
        echo 0 > "$TMP1"
fi

if [ ! -s "$TMP2" ]; then
        touch "$TMP2"
        echo 0 > "$TMP2"
fi

PREV_TOTAL=`cat $TMP1`
PREV_IDLE=`cat $TMP2`

CPU=(`cat /proc/stat | grep "^cpu$CORE "`) # Get the total CPU statistics.
unset CPU[0]                          # Discard the "cpu" prefix.
IDLE=${CPU[4]}                        # Get the idle CPU time.

# Calculate the total CPU time.
TOTAL=0
for VALUE in "${CPU[@]}"; do
let "TOTAL=$TOTAL+$VALUE"
done

# Calculate the CPU usage since we last checked.
let "DIFF_IDLE=$IDLE-$PREV_IDLE"
let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
echo -n "$DIFF_USAGE"

echo $TOTAL > "$TMP1"
echo $IDLE > "$TMP2"
