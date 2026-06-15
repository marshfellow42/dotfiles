hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("quickshell")
end)

--  To fix the microphone from sounding like a demon took over it, just install alsa-utils, go to alsamixer, press F6 to select your actual sound card (instead of <default>), press F5 to see all sound devices, then go to Internal (Internal Mic Boost) and put it on 0.

--  To make screen capture work, start the xdg-desktop-portal, and the hyprland already has the autostart ready on config
--  To check if xdg-desktop-portal is inactive (dead), run 'systemctl --user status xdg-desktop-portal'

--  If it is, then the settings should be like this

--  ~ ❯ systemctl --user cat xdg-desktop-portal.service
--  [Unit]
--  Description=Portal service
--  PartOf=graphical-session.target
--  #Requisite=graphical-session.target    #removed = workaround
--  Requires=dbus.service
--  After=dbus.service graphical-session-pre.target

--  [Service]
--  Type=dbus
--  BusName=org.freedesktop.portal.Desktop
--  ExecStart=/usr/lib/xdg-desktop-portal
--  Slice=session.slice

--  Then restart the xdg-desktop-portal, with 'systemctl --user restart xdg-desktop-portal'