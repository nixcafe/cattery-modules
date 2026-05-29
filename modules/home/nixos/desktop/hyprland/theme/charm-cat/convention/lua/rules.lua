-- window rules

-- All windows
hl.window_rule({ match = { title = ".*" }, no_blur = true })
hl.window_rule({ match = { float = false }, no_shadow = true })

-- Dialog float
hl.window_rule({ match = { title = "^(Open).*" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Save).*" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Choose).*" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Select).*" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Upload).*" }, float = true, center = true })
hl.window_rule({ match = { title = ".*(wants to save)$" }, float = true, center = true })
hl.window_rule({ match = { title = ".*(wants to open)$" }, float = true, center = true })

-- Picture-in-Picture
hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture).*" }, float = true, pin = true, keep_aspect_ratio = true })

-- Screen sharing indicator
hl.window_rule({ match = { title = ".*is sharing (a window|your screen).*" }, float = true, pin = true })

-- Layer rules
hl.layer_rule({ match = { namespace = ".*" }, xray = true })
hl.layer_rule({ match = { namespace = "gtk-layer-shell" }, blur = true, ignore_alpha = 0 })
