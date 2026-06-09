local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "quickshell ipc call appLauncher toggle"

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", function ()
    hl.dispatch(hl.dsp.focus({ last = true }))
    hl.dispatch(hl.dsp.window.swap({ next = true }))
    hl.dispatch(hl.dsp.focus({ last = true }))
end)
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind("Print", hl.dsp.exec_cmd([[
    SAVE_DIR="$(xdg-user-dir PICTURES)/Screenshots"
    mkdir -p "$SAVE_DIR"
    SCREENSHOT_PATH="$SAVE_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

    grim -g "$(slurp)" - | tee "$SCREENSHOT_PATH" | wl-copy --type image/png
]]))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd([[
    SAVE_DIR="$(xdg-user-dir PICTURES)/Screenshots"
    mkdir -p "$SAVE_DIR"
    SCREENSHOT_PATH="$SAVE_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

    grim "$SCREENSHOT_PATH"

    hyprctl eval "hl.config({ decoration = { screen_shader = '$HOME/.config/hypr/shaders/dim.glsl' } })"
    
    wl-copy --type image/png < "$SCREENSHOT_PATH" &

    sleep 0.5

    hyprctl eval "hl.config({ decoration = { screen_shader = '' } })"
    
    hyprctl reload
]]))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("CTRL + " .. mainMod .. " + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL + " .. mainMod .. " + left",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set 5%+"),                   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })