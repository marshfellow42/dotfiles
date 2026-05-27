-- Read the XDG_PICTURES_DIR environment variable
local xdg_pics = os.getenv("XDG_PICTURES_DIR")

-- Fallback to standard ~/Pictures if the environment variable isn't set
if not xdg_pics or xdg_pics == "" then
    xdg_pics = os.getenv("HOME") .. "/Pictures"
end

-- Dynamically assign it to mpv's screenshot directory
mp.set_property("screenshot-directory", xdg_pics)