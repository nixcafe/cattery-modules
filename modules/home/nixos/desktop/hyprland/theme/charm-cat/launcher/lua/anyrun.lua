hl.bind("SUPER + D", hl.dsp.exec_cmd("anyrun"))

hl.window_rule({ match = { class = ".*(anyrun).*" }, float = true })
hl.window_rule({ match = { class = ".*(anyrun).*" }, no_shadow = true })

hl.layer_rule({ match = { namespace = "anyrun" }, no_anim = true })
