hl.window_rule({ match = { class = "^(fcitx)$" }, pseudo = true })

hl.on("hyprland.start", function()
  hl.exec_cmd("fcitx5 -d --replace")
end)

hl.bind("ALT + E", hl.dsp.exec_cmd("pkill fcitx5 -9;sleep 1;fcitx5 -d --replace; sleep 1;fcitx5-remote -r"))
