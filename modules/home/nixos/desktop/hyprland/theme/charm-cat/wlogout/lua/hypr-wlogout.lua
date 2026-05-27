hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("pidof wlogout || wlogout"))

-- window rule
hl.window_rule({ match = { class = "^(wlogout)$" }, float = true })
hl.window_rule({ match = { class = "^(wlogout)$" }, move = { 0, 0 } })
hl.window_rule({ match = { class = "^(wlogout)$" }, size = { "monitor_w", "monitor_h" } })
hl.window_rule({ match = { class = "^(wlogout)$" }, animation = "slide" })
