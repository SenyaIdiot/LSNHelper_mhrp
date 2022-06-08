script_name('LSN-Helper')
script_description('Los Santos News Helper (LSNH) for special project MyHome RP')
script_author('kyrtion#7310')
script_version('1.0')

local sampev = require 'lib.samp.events'
require 'lib.moonloader'

function send(result)
	return sampAddChatMessage('LSNH » '.. result, -17740) -- -17740
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	send('Скрипт успешно загружено | 1.0')
	print('Script LSN-Helper 1.0 loaded - Discord: kyrtion#7310')

	while true do
		wait(0)
		-- тут коды для >>кнопки<< и вывод информации в <<локальном чате>>
	end
end

function sampev.onServerMessage(color, text)
	--print(color, '|', text)
	if color == -1616928769 and (
		text == "Подсказка: Чтобы открыть инвентарь, нажмите 'Y'" or
		text == "Подсказка: Чтобы взаимодействовать с ботом/игроком, нажмите 'пр. кнопка мыши' + 'H'" or
		text == "Подсказка: Чтобы открыть багажник машины, нажмите 'пр. кнопка мыши' + 'Прыжок'" or
		text == "Подсказка: Вы можете отключить помощь в /mm -> настройки"
	) then return false end

	if color == 2147418282 and (text:find('Пришло новое объявление на проверку, используйте: /edit') or text:find('запросил отказ на публикацию')) then
		if text:find('/edit') then printStyledString('/edit', 5000, 4) end
		send(text)
		return false
	end
	if color == -10059521 and (text:find('Отклонил объявление. Причина:') or text:find('Никто не подавал объявлений') or text:find('Данное объявление уже редактирует')) then
		send(text)
		return false
	end
	if color == -1 and text:find('За опубликованное сообщение вы получили') then
		TText = text:match('%{008000%}(%d+)$%{ffffff%}')
		send('За опубликованное сообщение вы получили '..TText..'$ на ваш банк. счёт.')
		return false
	end
	if color == -1 and text:find('Вы отклонили объявление') then
		return false
	end
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
	--print(id, style, title, button1, button2, text)
	if id == 1536 and title == '{6333FF}Публикация объявления' and text:find("%{ffffff%}Текст%:%{7FFF00%} (.*)") then
		adText = (text:match('%{ffffff%}Текст%:%{7FFF00%} (.*)%{ffffff%}')):gsub("\n", "")
		if adText:find('Ponolupсобес') then lua_thread.create(function() wait(0) sampSetCurrentDialogEditboxText('Ресторан "Ponolup Italy" ищет сотрудников. Ждём вас! GPS 9-51.') end)

		elseif adText:find('Ponolupгости') then lua_thread.create(function() wait(0) sampSetCurrentDialogEditboxText('Ресторан "Ponolup Italy" ждёт гостей! Насладись нашей кухней по адресу: GPS 9-51.') end)

		elseif adText:find('<< Собеседование >>') then lua_thread.create(function() wait(0) sampSetCurrentDialogEditboxText('Проводятся собеседования в бар "for Narcos". GPS 9-46.') end)

		elseif adText:find('<< Аммунация >>') then lua_thread.create(function() wait(0) sampSetCurrentDialogEditboxText('Самые дешёвые цены в городе, только в нашем AMMO "by Narcos". GPS 9-4.') end)

		else lua_thread.create(function() wait(0) sampSetCurrentDialogEditboxText(adText) end)
		end
	end
end