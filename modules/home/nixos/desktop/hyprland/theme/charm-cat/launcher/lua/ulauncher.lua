hl.bind("SUPER + D", hl.dsp.exec_cmd("ulauncher"))

-- window rule
hl.window_rule({ match = { class = ".*(ulauncher).*" }, float = true })
hl.window_rule({ match = { class = ".*(ulauncher).*" }, no_shadow = true })
