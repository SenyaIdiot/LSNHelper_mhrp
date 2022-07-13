local sampev = require 'lib.samp.events'
require 'lib.moonloader'

local lock = false

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	sampAddChatMessage('msg', -1)


	sampRegisterChatCommand('sa', sai)

	while true do
		wait(0)
		if isKeyJustPressed(VK_X) and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() then
			if lock == true then
				sampAddChatMessage('true', -1)
				sai()
			else
				sampAddChatMessage('false', -1)
				sai()
			end
		end
	end
end

function sai()
	lua_thread.create(function()
		lock = not lock
		--[[
			if lock == true then sampAddChatMessage('+ лок истинна', -1)
			elseif lock == false then sampAddChatMessage('- лок ложь', -1) end
		]]

		aw = 115
		if lock then
			while lock == true do
				setVirtualKeyDown(VK_W, true)
				wait(aw)
				setVirtualKeyDown(VK_W, false)
				setVirtualKeyDown(VK_D, true)
				wait(aw)
				setVirtualKeyDown(VK_D, false)
				setVirtualKeyDown(VK_S, true)
				wait(aw)
				setVirtualKeyDown(VK_S, false)
				setVirtualKeyDown(VK_A, true)
				wait(aw)
				setVirtualKeyDown(VK_A, false)
				wait(1)
			end
		end
	end)
end
