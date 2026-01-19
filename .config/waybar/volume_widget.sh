
#!/bin/bash

# Иконки (можно заменить на свои)
ICON_HIGH="🔊"
ICON_MID="🔉"
ICON_LOW="🔈"
ICON_MUTED="🔇"

# Максимальный уровень (100 % в PulseAudio/PipeWire)
MAX_VOLUME=65535  # 100% в числовом представлении PulseAudio

# Получение текущего уровня громкости и статуса mute
get_volume() {
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/Volume:/ {print $1}' | sed 's/[^0-9]//g')
    mute=$(pactl get-sink-mute @DEFAULT_SINK@ | grep "Mute: yes")
    echo "$vol $mute"
}

# Перевод числового значения в проценты
to_percent() {
    local num=$1
    echo $((num * 100 / MAX_VOLUME))
}

# Ограничение значения в пределах 0–MAX_VOLUME
clamp_volume() {
    local val=$1
    if [ $val -lt 0 ]; then
        echo 0
    elif [ $val -gt $MAX_VOLUME ]; then
        echo $MAX_VOLUME
    else
        echo $val
    fi
}

# Формирование вывода для Waybar
print_status() {
    read vol mute <<< $(get_volume)
    percent=$(to_percent $vol)

    if [ -n "$mute" ]; then
        echo "{\"text\": \"$ICON_MUTED MUTED\", \"class\": \"muted\", \"tooltip\": \"Громкость: $percent% (выключено)\"}"
    elif [ $percent -ge 75 ]; then
        echo "{\"text\": \"$ICON_HIGH $percent%\", \"tooltip\": \"Громкость: $percent%\"}"
    elif [ $percent -ge 25 ]; then
        echo "{\"text\": \"$ICON_MID $percent%\", \"tooltip\": \"Громкость: $percent%\"}"
    else
        echo "{\"text\": \"$ICON_LOW $percent%\", \"tooltip\": \"Громкость: $percent%\"}"
    fi
}

# Увеличение громкости (с ограничением в 100 %)
volume_up() {
    current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/Volume:/ {print $1}' | sed 's/[^0-9]//g')
    new_vol=$((current_vol + MAX_VOLUME * 5 / 100))  # +5%
    clamped_vol=$(clamp_volume $new_vol)
    pactl set-sink-volume @DEFAULT_SINK@ $clamped_vol
    print_status
}

# Уменьшение громкости
volume_down() {
    current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '/Volume:/ {print $1}' | sed 's/[^0-9]//g')
    new_vol=$((current_vol - MAX_VOLUME * 5 / 100))  # −5%
    clamped_vol=$(clamp_volume $new_vol)
    pactl set-sink-volume @DEFAULT_SINK@ $clamped_vol
    print_status
}

# Включение/выключение звука
volume_toggle() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    print_status
}

# Обработка аргументов
case "$1" in
    "status")
        print_status
        ;;
    "up")
        volume_up
        ;;
    "down")
        volume_down
        ;;
    "toggle")
        volume_toggle
        ;;
    *)
        echo "{\"text\": \"ERR\", \"tooltip\": \"Неизвестная команда\"}"
        ;;
esac
