local mainMod = "SUPER"

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + Delete", hl.dsp.exit())
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + S", hl.dsp.window.pseudo())

-- Focus next/prev window
hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "d" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next()) -- like most systems, focuses the next window on a workspace

-- Pin window
hl.bind(mainMod .. " + P", hl.dsp.window.pin())

-- Move window
hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Move" }) -- mouse

-- Resize window
hl.bind(mainMod .. " + CTRL + Left", hl.dsp.window.resize({ x = -12, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.window.resize({ x = 12, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + Up", hl.dsp.window.resize({ x = 0, y = -12, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + Down", hl.dsp.window.resize({ x = 0, y = 12, relative = true }), { repeating = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" }) -- mouse

-- Changes window split ratio
hl.bind(mainMod .. " + CTRL + Minus", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(mainMod .. " + CTRL + Equal", hl.dsp.layout("splitratio +0.1"), { repeating = true })

-- Fullscreen window
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())


-- Workspaces

-- Scroll switch workspace
-- mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + CTRL + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + CTRL + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + ALT + mouse_up", hl.dsp.focus({ workspace = "-1" }))
-- keyboard
hl.bind(mainMod .. " + BracketRight", hl.dsp.focus({ workspace = "+1" }), { repeating = true })
hl.bind(mainMod .. " + BracketLeft", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
-- ms windows switch workspace, but I don't like it
-- hl.bind(mainMod .. " + CTRL + Right", hl.dsp.focus({ workspace = "-1" }))
-- hl.bind(mainMod .. " + CTRL + Left", hl.dsp.focus({ workspace = "+1" }))

-- Specify switch workspace
hl.bind(mainMod .. " + mouse:274", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move window to workspaces
-- Scroll move window to workspace
hl.bind(mainMod .. " + SHIFT + BracketRight", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + BracketLeft", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + CTRL + BracketRight", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + CTRL + BracketLeft", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })

-- Specify move window to workspace
hl.bind(mainMod .. " + SHIFT + mouse:274", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + CTRL + mouse:274", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + SHIFT + CTRL + grave", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + SHIFT + CTRL + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + CTRL + 0", hl.dsp.window.move({ workspace = 10 }))
