-- window rule

-- All windows
hl.window_rule({ match = { title = ".*" }, no_blur = true }) -- no blur, convenient for specifying blur
hl.window_rule({ match = { float = false }, no_shadow = true }) -- no shadow, more flat

-- Dialogs float
hl.window_rule({ match = { title = "^.*(Open|Choose|Select|Save|Upload|File Upload).*.*" }, float = true })
