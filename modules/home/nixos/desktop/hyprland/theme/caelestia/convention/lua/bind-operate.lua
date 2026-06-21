local mainMod = "SUPER"
local goWsGroup = mainMod .. " + CTRL"       -- Ctrl+Super: navigate workspace groups
local moveWinToWs = mainMod .. " + ALT"       -- Super+Alt: move window to workspace
local moveWinToWsGroup = goWsGroup .. " + ALT" -- Ctrl+Super+Alt: move window to workspace group
local ctrlAlt = "CTRL + ALT"                   -- Ctrl+Alt: misc actions

-- Shell launcher (Super key opens launcher on release)
hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), { release = true })

-- Session / sidebar / lock (shell provides)
hl.bind(ctrlAlt .. " + Delete", hl.dsp.global("caelestia:session"))
hl.bind(mainMod .. " + N", hl.dsp.global("caelestia:sidebar"))
hl.bind(ctrlAlt .. " + C", hl.dsp.global("caelestia:clearNotifs"), { locked = true })
hl.bind(mainMod .. " + K", hl.dsp.global("caelestia:showall"))
hl.bind(mainMod .. " + L", hl.dsp.global("caelestia:lock"))

-- Restore lock
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("caelestia shell -d"), { locked = true })
hl.bind(mainMod .. " + ALT + L", hl.dsp.global("caelestia:lock"), { locked = true })

-- Brightness (shell provides)
hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), { locked = true })

-- Media (shell provides)
hl.bind(goWsGroup .. " + Space", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind(goWsGroup .. " + Equal", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind(goWsGroup .. " + Minus", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.global("caelestia:mediaStop"), { locked = true })

-- Kill/restart shell
hl.bind(goWsGroup .. " + SHIFT + R", hl.dsp.exec_cmd("qs -c caelestia kill"), { release = true })
hl.bind(moveWinToWsGroup .. " + R", hl.dsp.exec_cmd("qs -c caelestia kill; sleep .1; caelestia shell -d"), { release = true })

-- Screenshots (shell provides)
hl.bind("Print", hl.dsp.exec_cmd("caelestia screenshot"), { locked = true })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind(mainMod .. " + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshot"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("caelestia record -s"))
hl.bind(ctrlAlt .. " + R", hl.dsp.exec_cmd("caelestia record"))
hl.bind(mainMod .. " + SHIFT + ALT + R", hl.dsp.exec_cmd("caelestia record -r"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Clipboard and emoji picker
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"))
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
hl.bind(mainMod .. " + Period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))
hl.bind("CTRL + SHIFT + ALT + V", hl.dsp.exec_cmd([[sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"]]), { locked = true })

-- Sleep
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend-then-hibernate"), { locked = true })

------------------------------------------------------------
-- Workspace navigation

-- Go to workspace #
hl.bind(mainMod .. " + 1", hl.dsp.exec_cmd("wsaction workspace 1"))
hl.bind(mainMod .. " + 2", hl.dsp.exec_cmd("wsaction workspace 2"))
hl.bind(mainMod .. " + 3", hl.dsp.exec_cmd("wsaction workspace 3"))
hl.bind(mainMod .. " + 4", hl.dsp.exec_cmd("wsaction workspace 4"))
hl.bind(mainMod .. " + 5", hl.dsp.exec_cmd("wsaction workspace 5"))
hl.bind(mainMod .. " + 6", hl.dsp.exec_cmd("wsaction workspace 6"))
hl.bind(mainMod .. " + 7", hl.dsp.exec_cmd("wsaction workspace 7"))
hl.bind(mainMod .. " + 8", hl.dsp.exec_cmd("wsaction workspace 8"))
hl.bind(mainMod .. " + 9", hl.dsp.exec_cmd("wsaction workspace 9"))
hl.bind(mainMod .. " + 0", hl.dsp.exec_cmd("wsaction workspace 10"))

-- Go to workspace group #
hl.bind(goWsGroup .. " + 1", hl.dsp.exec_cmd("wsaction -g workspace 1"))
hl.bind(goWsGroup .. " + 2", hl.dsp.exec_cmd("wsaction -g workspace 2"))
hl.bind(goWsGroup .. " + 3", hl.dsp.exec_cmd("wsaction -g workspace 3"))
hl.bind(goWsGroup .. " + 4", hl.dsp.exec_cmd("wsaction -g workspace 4"))
hl.bind(goWsGroup .. " + 5", hl.dsp.exec_cmd("wsaction -g workspace 5"))
hl.bind(goWsGroup .. " + 6", hl.dsp.exec_cmd("wsaction -g workspace 6"))
hl.bind(goWsGroup .. " + 7", hl.dsp.exec_cmd("wsaction -g workspace 7"))
hl.bind(goWsGroup .. " + 8", hl.dsp.exec_cmd("wsaction -g workspace 8"))
hl.bind(goWsGroup .. " + 9", hl.dsp.exec_cmd("wsaction -g workspace 9"))
hl.bind(goWsGroup .. " + 0", hl.dsp.exec_cmd("wsaction -g workspace 10"))

-- Go to workspace -1/+1
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "+1" }))
hl.bind(goWsGroup .. " + Left", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind(goWsGroup .. " + Right", hl.dsp.focus({ workspace = "+1" }), { repeating = true })
hl.bind(mainMod .. " + Page_Up", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "+1" }), { repeating = true })

-- Go to workspace group -1/+1
hl.bind(goWsGroup .. " + mouse_down", hl.dsp.focus({ workspace = "-10" }))
hl.bind(goWsGroup .. " + mouse_up", hl.dsp.focus({ workspace = "+10" }))

-- Toggle special workspace
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("caelestia toggle specialws"))

-- Move window to workspace #
hl.bind(moveWinToWs .. " + 1", hl.dsp.exec_cmd("wsaction movetoworkspace 1"))
hl.bind(moveWinToWs .. " + 2", hl.dsp.exec_cmd("wsaction movetoworkspace 2"))
hl.bind(moveWinToWs .. " + 3", hl.dsp.exec_cmd("wsaction movetoworkspace 3"))
hl.bind(moveWinToWs .. " + 4", hl.dsp.exec_cmd("wsaction movetoworkspace 4"))
hl.bind(moveWinToWs .. " + 5", hl.dsp.exec_cmd("wsaction movetoworkspace 5"))
hl.bind(moveWinToWs .. " + 6", hl.dsp.exec_cmd("wsaction movetoworkspace 6"))
hl.bind(moveWinToWs .. " + 7", hl.dsp.exec_cmd("wsaction movetoworkspace 7"))
hl.bind(moveWinToWs .. " + 8", hl.dsp.exec_cmd("wsaction movetoworkspace 8"))
hl.bind(moveWinToWs .. " + 9", hl.dsp.exec_cmd("wsaction movetoworkspace 9"))
hl.bind(moveWinToWs .. " + 0", hl.dsp.exec_cmd("wsaction movetoworkspace 10"))

-- Move window to workspace group #
hl.bind(moveWinToWsGroup .. " + 1", hl.dsp.exec_cmd("wsaction -g movetoworkspace 1"))
hl.bind(moveWinToWsGroup .. " + 2", hl.dsp.exec_cmd("wsaction -g movetoworkspace 2"))
hl.bind(moveWinToWsGroup .. " + 3", hl.dsp.exec_cmd("wsaction -g movetoworkspace 3"))
hl.bind(moveWinToWsGroup .. " + 4", hl.dsp.exec_cmd("wsaction -g movetoworkspace 4"))
hl.bind(moveWinToWsGroup .. " + 5", hl.dsp.exec_cmd("wsaction -g movetoworkspace 5"))
hl.bind(moveWinToWsGroup .. " + 6", hl.dsp.exec_cmd("wsaction -g movetoworkspace 6"))
hl.bind(moveWinToWsGroup .. " + 7", hl.dsp.exec_cmd("wsaction -g movetoworkspace 7"))
hl.bind(moveWinToWsGroup .. " + 8", hl.dsp.exec_cmd("wsaction -g movetoworkspace 8"))
hl.bind(moveWinToWsGroup .. " + 9", hl.dsp.exec_cmd("wsaction -g movetoworkspace 9"))
hl.bind(moveWinToWsGroup .. " + 0", hl.dsp.exec_cmd("wsaction -g movetoworkspace 10"))

-- Move window to workspace -1/+1
hl.bind(mainMod .. " + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind(mainMod .. " + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(goWsGroup .. " + SHIFT + Right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind(goWsGroup .. " + SHIFT + Left", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })

-- Move window to/from special workspace
hl.bind(goWsGroup .. " + SHIFT + Up", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind(goWsGroup .. " + SHIFT + Down", hl.dsp.window.move({ workspace = "e+0" }))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:special" }))

------------------------------------------------------------
-- Touchpad gestures (macOS-like)

-- 3-finger horizontal swipe: workspace switch (1:1 follow-finger)
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- 4-finger horizontal swipe: workspace switch
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- 4-finger swipe up: mission control
hl.gesture({ fingers = 4, direction = "up", action = function() hl.dsp.global("caelestia:showall") end })

-- 4-finger swipe down: launchpad
hl.gesture({ fingers = 4, direction = "down", action = function() hl.dsp.global("caelestia:launcher") end })

-- 4-finger pinch: launchpad (exact macOS equivalent)
hl.gesture({ fingers = 4, direction = "pinchin", action = function() hl.dsp.global("caelestia:launcher") end })

-- 4-finger spread: showall
hl.gesture({ fingers = 4, direction = "pinchout", action = function() hl.dsp.global("caelestia:showall") end })

-- 3-finger swipe up: sidebar
hl.gesture({ fingers = 3, direction = "up", action = function() hl.dsp.global("caelestia:sidebar") end })

-- 3-finger swipe down: showall (app exposé)
hl.gesture({ fingers = 3, direction = "down", action = function() hl.dsp.global("caelestia:showall") end })

------------------------------------------------------------
-- Window groups

hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { repeating = true })
hl.bind("SHIFT + ALT + Tab", hl.dsp.window.cycle_next({ prev = true }), { repeating = true })
hl.bind(ctrlAlt .. " + Tab", hl.dsp.group.next(), { repeating = true })
hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.prev(), { repeating = true })
hl.bind(mainMod .. " + Comma", hl.dsp.group.toggle())
hl.bind(mainMod .. " + U", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + SHIFT + Comma", hl.dsp.group.lock_active({ action = "toggle" }))

------------------------------------------------------------
-- Window actions

hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + Minus", hl.dsp.window.resize({ x = -15, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + Equal", hl.dsp.window.resize({ x = 15, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Minus", hl.dsp.window.resize({ x = 0, y = -15, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Equal", hl.dsp.window.resize({ x = 0, y = 15, relative = true }), { repeating = true })

hl.bind(mainMod .. " + ALT + Left", hl.dsp.window.resize({ x = -15, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + Right", hl.dsp.window.resize({ x = 15, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + Up", hl.dsp.window.resize({ x = 0, y = -15, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + Down", hl.dsp.window.resize({ x = 0, y = 15, relative = true }), { repeating = true })

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Move" })
hl.bind(mainMod .. " + Z", hl.dsp.window.drag(), { mouse = true, description = "Window: Move" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" })
hl.bind(mainMod .. " + X", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" })

hl.bind(goWsGroup .. " + Backslash", hl.dsp.window.center())
hl.bind(moveWinToWsGroup .. " + Backslash", function()
  hl.dispatch(hl.dsp.window.resize({ x = "55%", y = "70%" }))
  hl.dispatch(hl.dsp.window.center())
end)

hl.bind(mainMod .. " + ALT + Backslash", hl.dsp.exec_cmd("caelestia resizer pip"))
hl.bind(mainMod .. " + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

------------------------------------------------------------
-- Special workspace toggles

hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("caelestia toggle sysmon"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("caelestia toggle music"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("caelestia toggle communication"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("caelestia toggle todo"))

------------------------------------------------------------
-- Apps (non-theme-specific)

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("app2unit -- zen-browser"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("app2unit -- codium"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("app2unit -- github-desktop"))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd("app2unit -- nemo"))
hl.bind(ctrlAlt .. " + Escape", hl.dsp.exec_cmd("app2unit -- qps"))
hl.bind(ctrlAlt .. " + V", hl.dsp.exec_cmd("app2unit -- pavucontrol"))
