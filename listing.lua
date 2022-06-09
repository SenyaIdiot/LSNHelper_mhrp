local sampev = require 'lib.samp.events'
require 'lib.moonloader'

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	while true do
		wait(0)
		-- тут коды для >>кнопки<< и вывод информации в <<локальном чате>>
		if isKeyJustPressed(VK_R) and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat('/edit')
            --sampAddChatMessage('ww', -1)
		end
	end
end

function sampev.onServerMessage(color, text)
	print(color, '|', text)
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    --1000   5   {6333FF}Публикация объявления
    if id ~= 1000 and style ~= 5 and title ~= '{6333FF}Публикация объявления' then
        print(id, style, title, button1, button2, text)
    end
end