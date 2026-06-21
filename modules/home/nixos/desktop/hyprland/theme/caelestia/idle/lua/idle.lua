-- hypridle: bridges lid-close -> logind sleep -> lock screen
-- (Caelestia's LogindManager does not reliably receive logind signals:
--  https://github.com/caelestia-dots/caelestia/issues/207)
hl.on("hyprland.start", function()
  hl.exec_cmd("hypridle")
end)
