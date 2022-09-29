#!/usr/bin/env bash

[[ -f /tmp/bg_pid ]] && kill `cat /tmp/bg_pid`

pic_dir="/usr/share/background"
if [[ -n $1 ]]; then
    pic_dir="$1"
fi

echo $$ > /tmp/bg_pid
while true; do
    for img in `eval find "$pic_dir" | shuf`; do
        feh --no-fehbg --bg-fill $img
        echo $img > /tmp/cur_bg
        sleep 1800
    done
done
