-- Execute the xdg-user-dir command to get the Pictures path
local handle = io.popen("xdg-user-dir PICTURES")
if handle ~= nil then
    local xdg_pics = handle:read("*l") .. "/mpvshot"
    handle:close()

    -- Fallback to standard ~/Pictures if the command fails or returns empty
    if not xdg_pics or xdg_pics == "" then
        xdg_pics = os.getenv("HOME") .. "/Pictures"
    end

    -- Dynamically assign it to mpv's screenshot directory
    mp.set_property("screenshot-directory", xdg_pics)
end
