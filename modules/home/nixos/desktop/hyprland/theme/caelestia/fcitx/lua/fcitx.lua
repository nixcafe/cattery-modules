hl.window_rule({ match = { class = "^(fcitx)$" }, pseudo = true })

hl.on("hyprland.start", function()
  hl.exec_cmd("fcitx5 -d --replace")
end)

hl.bind("SUPER + ALT + I", hl.dsp.exec_cmd("fcitx5 -r"))
