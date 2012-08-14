#!/bin/bash
# Příkazy, které se spouští po startu openboxu

# Vypnutí zvuků upozornění
xset b off &

# Vypnutí screensaveru
xset s off &

amixer -q set 'Master' 0%
amixer -q set 'Speaker' 100%
amixer -q set 'Headphone' 100%

# Nahrání fontů
xset +fp /usr/share/fonts/local
xset fp rehash

# Nastavení kurzoru myši - šipka místo křížku
xsetroot -cursor_name left_ptr

# Nastavení přepínatelného rozložení klávesnice (cz,us)
setxkbmap -layout cz,us -variant qwerty -option grp:alt_shift_toggle &

# Nastavení wallpaperu
feh --bg-scale /home/frostyx/images/wallpapers/darkness-wall.jpg &


trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --width 15 --height 20 --transparent true --tint 0x000000 &
sleep 3s && .dzen2/dzen2 &

# Spuštění conky
#conky -c /home/frostyx/.conky/conky &
#sleep 3s && .dzen2/dzen2 &
#conky -c /home/frostyx/.conky/todo &

# Spuštění ostatních aplikací
#gnome-keyring-daemon --start --foreground --components=secrets &
eval `gnome-ketring-daemon --start --components=secrets`
nm-applet &
#pidgin &
#xchat &
#uloz-to-daemon &

# Spuštění emulátorů terminálů na ploše
#xfce4-terminal --geometry 80x23+20+20 -x mocp &
#terminal --icon=/usr/share/icons/default.kde4/64x64/apps/krdc.png --title=IRSSI \
	--hide-menubar --geometry 100x23+10+475 -x screen irssi &


#urxvt -name music -e sh -c 'ncmpcpp -h 127.0.0.1 -p 6600'
pidgin &
claws-mail &

#screen -t irssi irssi &
#urxvt -name irssi -e sh -c 'screen -x -p irssi' &
