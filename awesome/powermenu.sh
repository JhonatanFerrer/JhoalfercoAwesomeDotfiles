
options=" 󰒲  Suspend\n 󰜉  Restart\n 󰐥  Shut down"
selected=$(echo -e "$options" | rofi -dmenu -p "" -l 3 -theme "$HOME"/.config/rofi/configpowermenu.rasi)

case "$selected" in
    " 󰐥  Shut down")
        shutdown now
        ;;
    " 󰜉  Restart")
        reboot
        ;;
    " 󰒲  Suspend")
        systemctl suspend
        ;;
    *)
        echo "Opción no válida"
        ;;
esac