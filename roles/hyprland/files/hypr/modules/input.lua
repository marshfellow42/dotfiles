hl.config({
    input = {
        kb_layout  = "br",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        persistent_warps = true,
    }
})

hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace"
})