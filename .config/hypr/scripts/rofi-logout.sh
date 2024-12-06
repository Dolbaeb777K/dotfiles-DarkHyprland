#!/bin/bash
# logout dialog

cmd=$(echo -e "Suspend\nReboot\nLogout\nPoweroff" | rofi -width 350 -dmenu -p system:)
# cmd=$(echo -e "󰒲   Suspend\n󱄌   Reboot\n󰿅   Logout\n   Poweroff" | rofi -width 350 -dmenu -p system:)
case $cmd in
    Suspend)
        systemctl suspend ;;
    Reboot)
        systemctl reboot ;;
    Logout)
        hyprctl dispatch exit 0 ;;
    Poweroff)
        systemctl poweroff ;;
esac
