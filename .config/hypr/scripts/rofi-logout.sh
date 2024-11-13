#!/bin/bash
# logout dialog

cmd=$(echo -e "󰒲   Suspend\n󱄌   Reboot\n󰿅   Logout\n   Poweroff" | rofi -width 350 -dmenu -p system:)
case $cmd in
    suspend)
        systemctl suspend ;;
    reboot)
        systemctl reboot ;;
    logout)
        hyprctl dispatch exit 0 ;;
    poweroff)
        systemctl poweroff ;;
esac
