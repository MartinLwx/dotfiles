local slowQuit = {}

slowQuit.delay = 1
slowQuit.timer = nil
slowQuit.alert = nil

function slowQuit:onKeyDown()
	local app = hs.application.frontmostApplication()
	self.timer = hs.timer.doAfter(self.delay, function()
		app:kill()
		self:reset()
	end)
	self.alert = hs.alert.show("Hold ⌘+Q to quit " .. app:name(), self.delay)
end

function slowQuit:reset()
	hs.alert.closeSpecific(self.alert)
	self.timer = nil
	self.alert = nil
end

function slowQuit:onKeyUp()
	if self.timer:running() then
		self.timer:stop()
		self:reset()
		hs.alert.show("Canceled", 0.25)
	end
end

hs.hotkey.bind({ "cmd" }, "q", function()
	slowQuit:onKeyDown()
end, function()
	slowQuit:onKeyUp()
end)

return slowQuit
