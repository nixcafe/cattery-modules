-- Window rules

-- Opaque windows (native transparency)
hl.window_rule({ match = { class = "^(foot|equibop|org\\.quickshell|imv|swappy)$" }, opaque = "1" })

-- Center all floating windows (not xwayland popups)
hl.window_rule({ match = { float = true, xwayland = false }, center = true })

-- Float windows
hl.window_rule({ match = { class = "^(guifetch|yad|zenity|wev|org\\.gnome\\.FileRoller|file-roller|blueman-manager|com\\.github\\.GradienceTeam\\.Gradience|feh|imv|system-config-printer|org\\.quickshell)$" }, float = true })

-- Float, resize and center
hl.window_rule({ match = { class = "^(foot)$", title = "^(nmtui)$" }, float = true, size = "60% 70%", center = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Settings)$" }, float = true, size = "70% 80%", center = true })
hl.window_rule({ match = { class = "^(org\\.pulseaudio\\.pavucontrol|yad-icon-browser)$" }, float = true, size = "60% 70%", center = true })
hl.window_rule({ match = { class = "^(nwg-look)$" }, float = true, size = "50% 60%", center = true })

-- Special workspaces
hl.window_rule({ match = { class = "^(btop)$" }, workspace = "special:sysmon" })
hl.window_rule({ match = { class = "^(feishin|Spotify|Supersonic|Cider|com\\.github\\.th_ch\\.youtube_music|Plexamp|com-maxrave-simpmusic-MainKt)$" }, workspace = "special:music" })
hl.window_rule({ match = { title = "^(Spotify( Free)?)$" }, workspace = "special:music" })
hl.window_rule({ match = { class = "^(discord|equibop|vesktop|whatsapp|org\\.telegram\\.desktop|slack)$" }, workspace = "special:communication" })
hl.window_rule({ match = { class = "^(Todoist)$" }, workspace = "special:todo" })

-- Dialogs
hl.window_rule({ match = { title = "^(Select|Open)( a)? (File|Folder)(s)?$" }, float = true })
hl.window_rule({ match = { title = "^File (Operation|Upload)( Progress)?$" }, float = true })
hl.window_rule({ match = { title = "^.* Properties$" }, float = true })
hl.window_rule({ match = { title = "^(Export Image as PNG|GIMP Crash Debug|Save As|Library)$" }, float = true })

-- Picture in picture
hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture).*" }, float = true, pin = true, keep_aspect_ratio = true })

-- Creative software
hl.window_rule({ match = { class = "^(krita|gimp|inkscape|darktable|resolve|kdenlive|shotcut|blender|godot)$" }, opaque = "1" })

-- Steam
hl.window_rule({ match = { class = "^(steam)$" }, rounding = 10 })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })

-- Games
hl.window_rule({ match = { class = "^(steam_app_(default|[0-9]+)|gamescope)$" }, opaque = "1", immediate = "1", idle_inhibit = "always" })

-- Minecraft launcher consoles
hl.window_rule({ match = { class = "^(com-atlauncher-App)$", title = "^(ATLauncher Console)$" }, float = true })
hl.window_rule({ match = { class = "^(PandoraLauncher)$", title = "^(Minecraft Game Output)$" }, float = true })

-- Autodesk Fusion 360
hl.window_rule({ match = { title = "^(Fusion360|(Marking Menu))$", class = "^(fusion360\\.exe)$" }, no_blur = true })

-- XWayland popups
hl.window_rule({ match = { xwayland = true, title = "^win[0-9]+$" }, no_dim = true, no_shadow = true, rounding = 10 })

-- Layer rules
hl.layer_rule({ match = { namespace = "^(hyprpicker)$" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "^(logout_dialog)$" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "^(selection)$" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "^(wayfreeze)$" }, animation = "fade" })

-- Fuzzel
hl.layer_rule({ match = { namespace = "^(launcher)$" }, animation = "popin 80%", blur = true })

-- Caelestia shell
hl.layer_rule({ match = { namespace = "^(caelestia-(border-exclusion|area-picker))$" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^(caelestia-(drawers|background))$" }, animation = "fade" })
