local sampev = require 'lib.samp.events'
require 'lib.moonloader'

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	while true do
		wait(0)
		-- тут коды для >>кнопки<< и вывод информации в <<локальном чате>>
		if isKeyDown(VK_R) and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat('/edit')
		end
	end
end

function sampev.onServerMessage(color, text)
	print(color, '|', text)
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
	print(id, style, title, button1, button2, text)
end