script_name('LSN-Helper')
script_description('Los Santos News Helper (LSNH) for special project MyHome RP')
script_author('kyrtion#7310')
script_properties('work-in-pause')
script_version('2.4')

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status

local imgui = require 'mimgui' -- теперь мимгуй, а не имгуй...
local encoding = require 'encoding'
local ffi = require 'ffi'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'

function json(filePath)
	local f = {}

	function f:read()
		local f = io.open(filePath, "r+")
		local jsonInString = f:read("*a")
		f:close()
		local jsonTable = decodeJson(jsonInString)
		return jsonTable
	end

	function f:write(t)
		f = io.open(filePath, "w")
		f:write(encodeJson(t))
		f:flush()
		f:close()
	end

	return f
end

encoding.default = 'CP1251'
u8 = encoding.UTF8


local fileJson = getWorkingDirectory()..'\\config\\saved_text_edition.json'
local list = {}

local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local renderWindow = new.bool(false)

local adInput = new.char[256]('')
local adNick, adPrice, adText = '', '', ''
local confirm = false
local block = false
local copying = false
local autoFocus = false
local hex = '0xEEDC82'

local update_state = false
local checkVerify = false
local lockVerify = false
local lockFailed = false
local newVersion = 'None'

local update_url = 'hhttps://raw.githubusercontent.com/kyrtion/LSNHelper_mhrp/master/version_lsn.ini' -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. '/update_lsn.ini' -- и тут свою ссылку
local script_vers = tostring(thisScript().version)
local script_url = 'https://github.com/kyrtion/LSNHelper_mhrp/blob/master/LSN-Helper.lua?raw=true' -- тут свою ссылку
local script_path = thisScript().path

function send(result) sampAddChatMessage('LSNH » '.. result, 0xEEDC82) end

imgui.OnInitialize(function() imgui.DarkTheme(); imgui.GetIO().IniFilename = nil; end)

local newFrame = imgui.OnFrame(
	function() return renderWindow[0] end,
	function(player)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 700, 340
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY * 1.04))
		imgui.Begin(u8'Публикация oбъявления | LSN-Helper '..thisScript().version, nil, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)

		imgui.SetCursorPos(imgui.ImVec2(20, 40)); imgui.TextColoredRGB('Отправитель:'); imgui.SameLine((sizeX - 15) / 2 + 10); imgui.TextColoredRGB('Цена:')
		imgui.SetCursorPos(imgui.ImVec2(20, 60));
		imgui.BeginChild('ChildWindows1', imgui.ImVec2(sizeX - 372, 25), true)
		imgui.TextColoredRGB('{FFFFFF}' .. adNick)
		imgui.EndChild()
		
		imgui.SameLine((sizeX - 15) / 2 + 10);

		imgui.BeginChild('ChildWindows2', imgui.ImVec2(sizeX - 372, 25), true)
		imgui.TextColoredRGB(adPrice)
		imgui.EndChild()
		
		imgui.SetCursorPos(imgui.ImVec2(20, 100))
		imgui.TextColoredRGB('Текст:')

		imgui.SetCursorPos(imgui.ImVec2(20, 120))

		imgui.BeginChild('ChildWindows3', imgui.ImVec2(sizeX - 40, 25), true)
		imgui.TextColoredRGB(adText)
		imgui.EndChild()


		imgui.SetCursorPos(imgui.ImVec2(20, 165))
		imgui.TextColoredRGB('Введите новый текст для этого объявления или оставьте поле пустым если его редактирование не нужно.')
		imgui.SetCursorPos(imgui.ImVec2(20, 180))
		imgui.TextColoredRGB('Вы так-же можете отклонить объявление с написанной в поле причиной и нажав после кнопку "Отклонить".')

		if copying then
			imgui.SetCursorPos(imgui.ImVec2(20, 210))
			imgui.TextColoredRGB('{FFAA00}Текст совпадает одной и тоже, скопировано в прошлом раз. Проверьте, всё правильно ли написано.')
		end

		imgui.SetCursorPos(imgui.ImVec2(20, sizeY - 110))
		imgui.PushItemWidth(sizeX - 40);

		if imgui.IsWindowAppearing() then imgui.SetKeyboardFocusHere(-1) end
		imgui.PushAllowKeyboardFocus(false)
		imgui.InputText(u8'', adInput, sizeof(adInput))
		imgui.PopAllowKeyboardFocus()

		imgui.SetCursorPos(imgui.ImVec2(20, sizeY - 60))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.34, 0.42, 0.51, 0.8))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.38, 0.48, 0.54, 0.57))
		if imgui.Button(u8'Передать в /rb', imgui.ImVec2((sizeX - 42) / 2 , 25)) then
			if (u8:decode(str(adInput))) == (nil or '') then
				send('В тексте пусто, зачем отправлять?', -1)
			else
				sampSendChat('/rb '.. adNick .. ' (' .. adPrice .. '): '.. adText)
			end
		end
		imgui.PopStyleColor(2)

		--! 
		imgui.SameLine((sizeX - 17) / 2 + 10)
		if imgui.Button(u8'Поиск (скоро)', imgui.ImVec2((sizeX - 42) / 2 , 25)) then
			send('Скоро', -1)
		end

		imgui.SetCursorPos(imgui.ImVec2(20, sizeY - 33))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.77, 0.33, 0.7))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.2, 0.77, 0.33, 0.57))
		if imgui.Button(u8'Опубликовать', imgui.ImVec2((sizeX - 42) / 2 , 25)) then
			local tempText = (u8:decode(str(adInput)))
			local Char = tempText:match('.+(%p)$')
			
			if (u8:decode(str(adInput))) == (nil or '') then
				send('В тексте пусто, зачем отправлять?', -1)

			elseif Char and Char ~= '$' then
				sampSendDialogResponse(1536,1,0,(u8:decode(str(adInput))))
				renderWindow[0] = false
				confirm = true

				lua_thread.create(function()
					list[adText] = (u8:decode(str(adInput)))
					json(fileJson):write(list)
				end)

				adNick, adPrice, adText = '', '', ''
			
			else
			    send('В конце знаки препинание не ставил!')
			end
		end
		imgui.PopStyleColor(2)
		
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 0.25, 0.25, 0.7))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.25, 0.25, 0.57))
		imgui.SameLine((sizeX - 17) / 2 + 10)
		if imgui.Button(u8'Отклонить', imgui.ImVec2((sizeX - 42) / 2 , 25)) then
			if (u8:decode(str(adInput))) == (nil or '') then
				send('Вы ничего не ввели в поле ввода', -1)
			else
				sampSendDialogResponse(1536,0,0,(u8:decode(str(adInput))))
				
				renderWindow[0] = false
				copying = false

				adNick, adPrice, adText = '', '', ''

				lua_thread.create(function()
					wait(300)
					sampSendChat('/edit')
				end)

			end
		end
		imgui.PopStyleColor(2)
		
		imgui.End()
	end
)

function main()
	while not isSampAvailable() do wait(0) end
	if not doesFileExist(fileJson) then json(fileJson):write({}) end -- если нет файла, то создаем его
	list = json(fileJson):read() -- получаем массив из файла file
	send('Скрипт успешно загружено | '..thisScript().version)
	print(); print('Script LSN-Helper '..thisScript().version..' loaded - Discord: kyrtion#7310')

	--! debug window (dont use)
	sampRegisterChatCommand('dia', function()
		renderWindow[0] = not renderWindow[0]
		imgui.StrCopy(adInput, u8(adText))
		autoFocus = true
	end)

	sampRegisterChatCommand('verify', function()
		if lockVerify then
			checkVerify = true
			send('Обновляю '..script_vers ..' -> '..updateIni.info.version..' ...')
			lockVerify = false
		end
	end)

    downloadUrlToFile(update_url, update_path, function(id, status)
		sampAddChatMessage('downloading', -1)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			sampAddChatMessage('succes', -1)
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.version) ~= script_vers then
                newVersion = updateIni.info.version
                send('Есть обновление! Версия: '..updateIni.info.version..'. Чтобы обновить вводите /verify', -1)
                update_state = true
                lockVerify = true
            end
			sampAddChatMessage('removed update_lsn.ini', -1)
            --os.remove(update_path)
        end
    end)
	
	while true do
		wait(0)
		if update_state and checkVerify then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    send('Скрипт успешно обновлен! Сейчас будет перезагружен', -1)
                    lockFailed = true
                    thisScript():reload()
                end
            end)
            break
        end
	end
end



function onWindowMessage(msg, wparam, lparam)
	if msg == 0x100 or msg == 0x101 then
		if (wparam == VK_ESCAPE and (renderWindow[0])) and not isPauseMenuActive() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
			consumeWindowMessage(true, false)
		end
	end
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
	if id == 1536 and title == '{6333FF}Публикация объявления' then
		--local adN = ''
		--adN = ( text:match('%{ffffff%}Отправитель%: %{7FFF00%}(%w+ %w+)') ):gsub("\n", "")
		adText = ( text:match('%{ffffff%}Текст%:%{7FFF00%} (.*)%{ffffff%}') ):gsub("\n", "")
		adPrice = ( text:match('%{ffffff%}Цена%:%{7FFF00%} (.*)%{FFFFFF%}') ):gsub("\n", "")
		renderWindow[0] = true
		autoFocus = true
		if list[adText] == nil then
			imgui.StrCopy(adInput, u8(adText))
			copying = false
		else	
			imgui.StrCopy(adInput, u8(list[adText]))
			copying = true
		end
		return false

	elseif id == 1537 and title == '{6333FF}Публикация объявления: {ffffff}Подтверждение' and confirm then
		sampSendDialogResponse(1537,1,0,0)
		confirm = false
		return false
	end
end

function sampev.onSendDialogResponse(dialogId, button, listboxId, input)
	if dialogId == 1000 and button == 1 then
		local fr = ''; fr, adNick = input:match('(%d+)%. (.*)')
	end
end

function sampev.onServerMessage(color, text)
	if color == 2147418282 then
		if text:find('новое объявление на проверку') then
			printStyledString('/edit', 5000, 4)
			send(text)
			return false

		elseif text:find('запросил отказ на публикацию') then
			send(text)
			return false
			
		end
	end

	if color == -1616928769 and (text == "Подсказка: Чтобы открыть инвентарь, нажмите 'Y'" or
								 text == "Подсказка: Чтобы взаимодействовать с ботом/игроком, нажмите 'пр. кнопка мыши' + 'H'" or
								 text == "Подсказка: Чтобы открыть багажник машины, нажмите 'пр. кнопка мыши' + 'Прыжок'" or
								 text == "Подсказка: Вы можете отключить помощь в /mm -> настройки"
		) then return false
	end

	if color == -10059521 and (text:find('Отклонил объявление. Причина:') or
							   text:find('Никто не подавал объявлений') or
							   text:find('Данное объявление уже редактирует') or
							   text:find('Тот, кто подал объявление, покинул сервер')
		) then
		send(text)
		return false
	end

	if color == -1 and text:find('За опубликованное сообщение вы получили') then
		TText = text:match('%{008000%}(%d+)$%{ffffff%}')
		send('За опубликованное сообщение вы получили '..TText..'$ на ваш банк. счёт.')
		
		lua_thread.create(function()
			wait(100)
			sampSendChat('/edit')
		end)

		return false
	end

	if color == -1 and (text:find('Вы отклонили объявление') or text:find('Тот, кто подал объявление, покинул сервер')) then
		send(text)
		return false
	end

	--! этот код только в самом конце функции
	if color == 2147418282 and text:find('[News Studio]') then
		if text:match('%[News Studio%] (.*) %|') then 
			wtfac = text:match('%[News Studio%] (.*) %|')
			print('>> [' .. wtfac .. ']')
			return true
		end
	end
end

function imgui.TextColoredRGB(text)
	local style = imgui.GetStyle()
	local colors = style.Colors
	local ImVec4 = imgui.ImVec4

	local explode_argb = function(argb)
		local a = bit.band(bit.rshift(argb, 24), 0xFF)
		local r = bit.band(bit.rshift(argb, 16), 0xFF)
		local g = bit.band(bit.rshift(argb, 8), 0xFF)
		local b = bit.band(argb, 0xFF)
		return a, r, g, b
	end

	local getcolor = function(color)
		if color:sub(1, 6):upper() == 'SSSSSS' then
			local r, g, b = colors[1].x, colors[1].y, colors[1].z
			local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
			return ImVec4(r, g, b, a / 255)
		end
		local color = type(color) == 'string' and tonumber(color, 16) or color
		if type(color) ~= 'number' then return end
		local r, g, b, a = explode_argb(color)
		return imgui.ImVec4(r/255, g/255, b/255, a/255)
	end

	local render_text = function(text_)
		for w in text_:gmatch('[^\r\n]+') do
			local text, colors_, m = {}, {}, 1
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				local color = getcolor(w:sub(n + 1, k - 1))
				if color then
					text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
					colors_[#colors_ + 1] = color
					m = n
				end
				w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
			end
			if text[0] then
				for i = 0, #text do
					imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else imgui.Text(u8(w)) end
		end
	end

	render_text(text)
end

function imgui.DarkTheme()
	imgui.SwitchContext()
	--==[ STYLE ]==--
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
	imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().IndentSpacing = 0
	imgui.GetStyle().ScrollbarSize = 10
	imgui.GetStyle().GrabMinSize = 10

	--==[ BORDER ]==--
	imgui.GetStyle().WindowBorderSize = 1
	imgui.GetStyle().ChildBorderSize = 1
	imgui.GetStyle().PopupBorderSize = 1
	imgui.GetStyle().FrameBorderSize = 1
	imgui.GetStyle().TabBorderSize = 1

	--==[ ROUNDING ]==--
	imgui.GetStyle().WindowRounding = 5
	imgui.GetStyle().ChildRounding = 5
	imgui.GetStyle().FrameRounding = 5
	imgui.GetStyle().PopupRounding = 5
	imgui.GetStyle().ScrollbarRounding = 5
	imgui.GetStyle().GrabRounding = 5
	imgui.GetStyle().TabRounding = 5

	--==[ ALIGN ]==--
	imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
	
	--==[ COLORS ]==--
	imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
	imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
	imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
	imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
	imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
	imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
	imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
	imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
	imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end

function onScriptTerminate(s, q)
	if s == thisScript() then
		send('Что-то пошло не так с скриптом... Отключаем', -1)
		return true
	end
end
