-- PaperWM - Scrollable window tiling (niri-style keybinds with option)
PaperWM = hs.loadSpoon("PaperWM")
PaperWM:bindHotkeys({
  -- Focus windows (opt+H/L)
  focus_left  = { { "alt" }, "h" },
  focus_right = { { "alt" }, "l" },
  focus_up    = { { "alt" }, "k" },
  focus_down  = { { "alt" }, "j" },

  -- Move windows (opt+ctrl+H/L)
  swap_left  = { { "alt", "ctrl" }, "h" },
  swap_right = { { "alt", "ctrl" }, "l" },
  swap_up    = { { "alt", "ctrl" }, "k" },
  swap_down  = { { "alt", "ctrl" }, "j" },

  -- Position and resize
  center_window = { { "alt" }, "c" },
  full_width    = { { "alt" }, "f" },
  cycle_width   = { { "alt" }, "r" },

  -- Resize width
  decrease_width = { { "alt" }, "-" },
  increase_width = { { "alt" }, "=" },

  -- Floating
  toggle_floating = { { "alt" }, "v" },

  -- Switch spaces (opt+1-9)
  switch_space_1 = { { "alt" }, "1" },
  switch_space_2 = { { "alt" }, "2" },
  switch_space_3 = { { "alt" }, "3" },
  switch_space_4 = { { "alt" }, "4" },
  switch_space_5 = { { "alt" }, "5" },
  switch_space_6 = { { "alt" }, "6" },
  switch_space_7 = { { "alt" }, "7" },
  switch_space_8 = { { "alt" }, "8" },
  switch_space_9 = { { "alt" }, "9" },

  -- Move window to space (opt+shift+1-9)
  move_window_1 = { { "alt", "shift" }, "1" },
  move_window_2 = { { "alt", "shift" }, "2" },
  move_window_3 = { { "alt", "shift" }, "3" },
  move_window_4 = { { "alt", "shift" }, "4" },
  move_window_5 = { { "alt", "shift" }, "5" },
  move_window_6 = { { "alt", "shift" }, "6" },
  move_window_7 = { { "alt", "shift" }, "7" },
  move_window_8 = { { "alt", "shift" }, "8" },
  move_window_9 = { { "alt", "shift" }, "9" },
})
PaperWM:start()
