mp.add_forced_key_binding("SPACE", "replay-if-eof", function()
    local eof = mp.get_property("eof-reached")
    if eof == "yes" then
        mp.commandv("seek", "0", "absolute+exact")
        mp.set_property_bool("pause", false)
    else
        mp.command("cycle pause")
    end
end, {repeatable = false})