hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("anyrun"), { release = true })

hl.window_rule({ match = { class = ".*(anyrun).*" }, float = true })
hl.window_rule({ match = { class = ".*(anyrun).*" }, no_shadow = true })

hl.layer_rule({ match = { namespace = "anyrun" }, no_anim = true })
