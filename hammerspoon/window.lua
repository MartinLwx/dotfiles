-- half of screen
-- shortcuts: option + cmd + arrow keys
hs.hotkey.bind({ "option", "cmd" }, "left", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 1 })
end)
hs.hotkey.bind({ "option", "cmd" }, "right", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 1 })
end)
hs.hotkey.bind({ "option", "cmd" }, "up", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 0.5 })
end)
hs.hotkey.bind({ "option", "cmd" }, "down", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0.5, 1, 0.5 })
end)

-- quarter of screen
-- shortcuts: ctrl + option + cmd +
--   [[
--     u i
--     j k
--   ]]
hs.hotkey.bind({ "ctrl", "option", "cmd" }, "u", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 0.5 })
end)
hs.hotkey.bind({ "ctrl", "option", "cmd" }, "k", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0.5, 0.5, 0.5 })
end)
hs.hotkey.bind({ "ctrl", "option", "cmd" }, "i", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 0.5 })
end)
hs.hotkey.bind({ "ctrl", "option", "cmd" }, "j", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0.5, 0.5, 0.5 })
end)

-- full screen
-- shortcut: option + cmd + f
hs.hotkey.bind({ "alt", "cmd" }, "f", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 1 })
end)

-- center screen
-- shortcut: option + cmd + c
hs.hotkey.bind({ "alt", "cmd" }, "c", function()
	hs.window.focusedWindow():centerOnScreen()
end)
