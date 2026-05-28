# alias notifs='dunstctl set-paused toggle'

function notifs() {
    case "$1" in
        on)  dunstctl set-paused false ;;
        off) dunstctl set-paused true ;;
        *)   dunstctl set-paused toggle ;;
    esac

    if dunstctl is-paused | grep -q true; then
        echo "Notifications: OFF"
    else
        echo "Notifications: ON"
    fi
}
