hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output -o ~/Pictures/Screenshots -- nomacs"))
hl.bind("F6", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots"), { locked = true })

-- window rule
hl.window_rule({ match = { class = "^(nomacs)$" }, float = true })
