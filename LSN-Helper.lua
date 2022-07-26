script_name('LSN-Helper')
script_description('Los Santos News Helper (LSN-Helper) for special project MyHome RP')
script_author('kyrtion#7310')
script_properties('work-in-pause')
script_version('4.1')

require 'lib.moonloader'
local dlstatus = require('moonloader').download_status

if not doesDirectoryExist('moonloader/config') then createDirectory('moonloader/config') end
if not doesDirectoryExist('moonloader/config/LSN-Helper') then createDirectory ('moonloader/config/LSN-Helper') end

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

local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof

local editJson = getWorkingDirectory()..'/config/LSN-Helper/new_edit.json'; local editList = {}
local adJson = getWorkingDirectory()..'/config/LSN-Helper/ad.json'; local adList = {}
local logJson = getWorkingDirectory()..'/config/LSN-Helper/log.json'; local logList = {}

local renderWindow = new.bool(false)
local menuWindow = new.bool(false)

local adInput = new.char[256]('')
local searchInput = new.char[256]('')
local searchLog = new.char[256]('')
local searchSelf = new.char[256]('')

--local adNick, adPrice, adText = 'Awe Some[123]', '138$', 'awesome text, dude'
local adNick, adPrice, adText = '', '', ''
local notAdNick = false
local confirm = false
local block = false
local copying = false
local hex = '0xEEDC82'

local update_state = false
local checkVerify = false
local lockVerify = false
local lockFailed = false
local newVersion = 'None'
local oldVersion = 'None'

--! origin/master
local update_url = 'https://raw.githubusercontent.com/kyrtion/LSNHelper_mhrp/master/version_lsn.ini'
local update_path = getWorkingDirectory() .. '/update_lsn.ini'
local script_vers = tostring(thisScript().version)
local script_url = 'https://github.com/kyrtion/LSNHelper_mhrp/blob/master/LSN-Helper.lua?raw=true'
local script_path = thisScript().path

-- --! origin/beta
-- local update_url = 'https://raw.githubusercontent.com/kyrtion/LSNHelper_mhrp/beta/version_lsn.ini'
-- local update_path = getWorkingDirectory() .. '/update_lsn.ini'
-- local script_vers = tostring(thisScript().version)
-- local script_url = 'https://github.com/kyrtion/LSNHelper_mhrp/blob/beta/LSN-Helper.lua?raw=true'
-- local script_path = thisScript().path

function send(result) sampAddChatMessage('LSN-Helper » '.. result, 0xEEDC82) end

imgui.OnInitialize(function() imgui.DarkTheme(); imgui.GetIO().IniFilename = nil; end)

local newFrame = imgui.OnFrame(
	function() return renderWindow[0] end,
	function(player)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 700, 340
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY * 1.04))
		imgui.Begin(u8'Публикация oбъявления | LSN-Helper '..thisScript().version, nil, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

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
		imgui.TextColoredRGB('Введите новый текст для этого объявления. Но не оставьте поле пустым!')

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
		imgui.InputText(u8'##adInput', adInput, sizeof(adInput))
		imgui.PopAllowKeyboardFocus()

		imgui.SetCursorPos(imgui.ImVec2(20, sizeY - 60))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.34, 0.42, 0.51, 1.0))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.34, 0.42, 0.51, 0.9))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.34, 0.42, 0.51, 0.8))
		if imgui.Button(u8'Передать в /rb', imgui.ImVec2((sizeX - 42) / 2 , 25)) then
			if (u8:decode(adText)) == (nil or '') then
				send('В тексте пусто, зачем сообщать?', -1)
			else
				sampSendChat('/rb '.. adNick .. ' (' .. adPrice .. '): '.. adText)
			end
		end
		imgui.PopStyleColor(3)

		imgui.SameLine((sizeX - 17) / 2 + 10)
		if imgui.Button(u8'Поиск', imgui.ImVec2((sizeX - 42) / 2 , 25)) then
			imgui.OpenPopup(u8'Поиск')
		end

		if imgui.BeginPopupModal(u8'Поиск', _, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
			local pSize = imgui.ImVec2(770, 400)
			imgui.SetWindowSizeVec2(pSize)
			
			imgui.SetCursorPos(imgui.ImVec2(20, 45))
			imgui.Text(u8'Текст:') imgui.SameLine(70) imgui.TextColoredRGB(adText)
			
			imgui.SetCursorPos(imgui.ImVec2(20, 70)) imgui.Text(u8'Поиск:')
			
			imgui.SetCursorPos(imgui.ImVec2(70, 66))
			imgui.PushItemWidth(pSize.x/2 + 294)

			if imgui.IsWindowAppearing() then imgui.SetKeyboardFocusHere(-1) end
			imgui.PushAllowKeyboardFocus(false)
			if imgui.InputText('##searchInput', searchInput, sizeof(searchInput)) then str(searchInput):find(str(searchInput):gsub("%p", "%%%1")) end
			imgui.PopAllowKeyboardFocus()
			imgui.PopItemWidth()
			
			imgui.SetCursorPos(imgui.ImVec2(21, 108))
			imgui.Text(u8'Результаты:')
			
			imgui.SetCursorPos(imgui.ImVec2(20, 130))
			imgui.BeginChild('ChildWindowsS', imgui.ImVec2(pSize.x/2 + 344, pSize.y/2 + 12), true)
			--imgui.Separator()

			for i=1, #editList do
				if string.len(str(searchInput)) ~= 0 then
					if string.find(u8(editList[i].new_text), str(searchInput), 1, true) then
						local ss = editList[i].new_text
						imgui.Columns(2)
						if imgui.Selectable(u8' >##'..i, true, _, imgui.ImVec2(20, 15)) then
							imgui.StrCopy(adInput, u8(ss))
							imgui.CloseCurrentPopup()
							searchInput = new.char[256]('')
						end
						imgui.SameLine(32)
						if imgui.Selectable(u8' RB##'..i, true, _, imgui.ImVec2(20, 15)) then
							sampSendChat('/rb $ >> '..ss)
						end
						imgui.SetColumnWidth(0, 57)
						imgui.NextColumn()
						imgui.TextColoredRGB('{68E625}$ {FFFFFF}'..ss)
						--imgui.Text(u8(editList[i].employee))
						imgui.NextColumn()
						imgui.Separator()
					end
				else
					local ss = editList[i].new_text
					imgui.Columns(2)
					if imgui.Selectable(u8' >##'..i, true, _, imgui.ImVec2(20, 15)) then
						imgui.StrCopy(adInput, u8(ss))
						imgui.CloseCurrentPopup()
						searchInput = new.char[256]('')
					end
					imgui.SameLine(32)
					if imgui.Selectable(u8' RB##'..i, true, _, imgui.ImVec2(20, 15)) then
						sampSendChat('/rb $ >> '..ss)
					end
					imgui.SetColumnWidth(0, 57)
					imgui.NextColumn()
					imgui.TextColoredRGB('{68E625}$ {FFFFFF}'..ss)
					--imgui.Text(u8(editList[i].employee))
					imgui.NextColumn()
					imgui.Separator()
				end
			end

			for i=1, #logList do
				if string.len(str(searchInput)) ~= 0 then
					if string.find(u8(logList[i].text), str(searchInput), 1, true) then
						local ss = (logList[i].text):match('(.*)%s%|')
						imgui.Columns(2)
						if imgui.Selectable(u8' >##'..i, true, _, imgui.ImVec2(20, 15)) then
							imgui.StrCopy(adInput, u8(ss))
							imgui.CloseCurrentPopup()
							searchInput = new.char[256]('')
						end
						imgui.SameLine(32)
						if imgui.Selectable(u8' RB##'..i, true, _, imgui.ImVec2(20, 15)) then
							sampSendChat('/rb >> '..ss)
						end
						imgui.SetColumnWidth(0, 57)
						imgui.NextColumn()
						imgui.Text(u8(ss))
						--imgui.Text(u8(logList[i].employee))
						imgui.NextColumn()
						imgui.Separator()
					end
				else
					local ss = (logList[i].text):match('(.*)%s%|')
					imgui.Columns(2)
					if imgui.Selectable(u8' >##'..i, true, _, imgui.ImVec2(20, 15)) then
						imgui.StrCopy(adInput, u8(ss))
						imgui.CloseCurrentPopup()
						searchInput = new.char[256]('')
					end
					imgui.SameLine(32)
					if imgui.Selectable(u8' RB##'..i, true, _, imgui.ImVec2(20, 15)) then
						sampSendChat('/rb >> '..ss)
					end
					imgui.SetColumnWidth(0, 57)
					imgui.NextColumn()
					imgui.Text(u8(ss))
					--imgui.Text(u8(logList[i].employee))
					imgui.NextColumn()
					imgui.Separator()
				end
			end



			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(20, pSize.y - 42))
			if imgui.Button(u8'Закрыть', imgui.ImVec2(pSize.x/2 + 344, 25)) then
				searchInput = new.char[256]('')
				imgui.CloseCurrentPopup()
			end
	
			imgui.EndPopup()
		end

		imgui.SetCursorPos(imgui.ImVec2(20, sizeY - 33))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.77, 0.33, 1.0))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.2, 0.77, 0.33, 0.9))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.77, 0.33, 0.8))
		if imgui.Button(u8'Опубликовать', imgui.ImVec2((sizeX - 42) / 2 , 25)) then
			local tempText = (u8:decode(str(adInput)))
			local Char = tempText:match('.*(%p)$')
			
			if (u8:decode(str(adInput))) == (nil or '') then
				send('В тексте пусто, зачем отправлять?')
			elseif Char == '.' or Char == '?' or Char == '!' then
				renderWindow[0] = false
				sampSendDialogResponse(1536, 1, 0, (u8:decode(str(adInput))))
				confirm = true
				local list = {
					date = os.date('%Y.%m.%d %X'),
					player = adNick,
					old_text = adText,
					new_text = u8:decode(str(adInput))
				}
				--editList[adText] = (u8:decode(str(adInput)))
				--json(editJson):write(editList)
				table.insert(editList, list)
				table.sort(editList, function(a,b) return a.date > b.date end)
				json(editJson):write(editList)
				adNick, adPrice, adText = '', '', ''
				copying = false
			else
				send('Вы не ставили в конце знаки препинание')
				--send('<'..Char..'>')
			end
		end
		imgui.PopStyleColor(3)
		
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 0.25, 0.25, 1.0))
		imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.25, 0.25, 0.9))
		imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1.00, 0.25, 0.25, 0.8))
		imgui.SameLine((sizeX - 17) / 2 + 10)
		if imgui.Button(u8'Отклонить', imgui.ImVec2((sizeX - 42) / 2 , 25)) then
			if (u8:decode(str(adInput))) == (nil or '') then
				send('Вы не указали причину в поле')
			else
				renderWindow[0] = false
				sampSendDialogResponse(1536, 0, 0, (u8:decode(str(adInput))))
				copying = false
				adNick, adPrice, adText = '', '', ''
				lua_thread.create(function() wait(300) sampSendChat('/edit') end)
			end
		end
		imgui.PopStyleColor(3)
		
		imgui.End()
	end
)
local tab = new.int(1)
local menuFrame = imgui.OnFrame(
	function() return menuWindow[0] end,
	function(player)
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 960, 400
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'Меню | LSN-Helper '..tostring(thisScript().version), menuWindow, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		
		local csbutt = imgui.ImVec2(sizeX - 647, 25)
		if imgui.Button(u8'Главная', csbutt) then tab[0] = 1 end
		imgui.SameLine()
		--
		if imgui.Button(u8'Готовое объявление', csbutt) then tab[0] = 2 end
		imgui.SameLine()
		--
		if imgui.Button(u8'Логи', csbutt) then tab[0] = 3 end

		local childSize = sizeX - 100
		imgui.SetCursorPos(imgui.ImVec2(5, 65))
		imgui.BeginChild('menushka', imgui.ImVec2(sizeX - 10, sizeY - 70), true)
		if tab[0] == 1 then -- Раздел "Настройка"
			imgui.SetCursorPos(imgui.ImVec2(5, 8))
			imgui.TextColoredRGB('Классная настройка. Coming soon...')

		elseif tab[0] == 2 then -- Раздел "Готовое объявление"
			imgui.SetCursorPos(imgui.ImVec2(5, 8))
			imgui.Text(u8'Поиск: ')

			imgui.SetCursorPos(imgui.ImVec2(50, 5))
			imgui.PushItemWidth(sizeX - 370)
			if imgui.InputText('##searchSelf', searchSelf, sizeof(searchSelf)) then str(searchSelf):find(str(searchSelf):gsub("%p", "%%%1")) end
			imgui.PopItemWidth()

			imgui.SetCursorPos(imgui.ImVec2(5, 33))
			imgui.BeginChild('ChildWin1', imgui.ImVec2(sizeX/2 + 460, sizeY/2 + 92), true)
			local sbutt = imgui.ImVec2(50, 15)
			for i=1, #editList do
				--if editList[i].type == 'self' then
					if string.len(str(searchSelf)) ~= 0 then
						if string.find(u8(editList[i].old_text), str(searchSelf), 1, true) or string.find(u8(editList[i].new_text), str(searchSelf), 1, true) then
							imgui.Columns(2)
							if imgui.Selectable(u8'EDIT##'..tonumber(i), true, _, sbutt) then
								imgui.OpenPopup(u8'Редактирование готового объявления | LSN-Helper '..thisScript().version)
								idNew = i
								newTextInput = new.char[256](u8(editList[i].old_text))
								newTextUpdInput = new.char[256](u8(editList[i].new_text))
							end
							if imgui.Selectable(u8'DELETE##'..tonumber(i), true, _, sbutt) then
								imgui.OpenPopup(u8'Удаление готового объявления | LSN-Helper '..thisScript().version)
								idDel = i
								delText = editList[i].old_text
								delNewText = editList[i].new_text
							end
							imgui.SetColumnWidth(0, 60)
							imgui.NextColumn()
							imgui.TextColoredRGB('{ffffff}Старый {68E625}$ {ffffff}'..editList[i].old_text)
							imgui.TextColoredRGB('{ffffff}Новый {68E625}$ {ffffff}'..editList[i].new_text)
							imgui.NextColumn()
							imgui.Separator()
						end
					else
						imgui.Columns(2)
						if imgui.Selectable(u8'EDIT##'..tonumber(i), true, _, sbutt) then
							imgui.OpenPopup(u8'Редактирование готового объявления | LSN-Helper '..thisScript().version)
							idNew = i
							newTextInput = new.char[256](u8(editList[i].old_text))
							newTextUpdInput = new.char[256](u8(editList[i].new_text))
						end
						if imgui.Selectable(u8'DELETE##'..tonumber(i), true, _, sbutt) then
							imgui.OpenPopup(u8'Удаление готового объявления | LSN-Helper '..thisScript().version)
							idDel = i
							delText = editList[i].old_text
							delNewText = editList[i].new_text
						end
						imgui.SetColumnWidth(0, 60)
						imgui.NextColumn()
						imgui.TextColoredRGB('{ffffff}Старый {68E625}$ {ffffff}'..editList[i].old_text)
						imgui.TextColoredRGB('{ffffff}Новый {68E625}$ {ffffff}'..editList[i].new_text)
						imgui.NextColumn()
						imgui.Separator()
					end
				--end
			end
			if imgui.BeginPopupModal(u8'Редактирование готового объявления | LSN-Helper '..thisScript().version, _, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
				local sizeX, sizeY = 800, 155; local vecs = imgui.ImVec2(sizeX, sizeY); imgui.SetWindowSizeVec2(vecs)

				imgui.SetCursorPos(imgui.ImVec2(20, 40)); imgui.TextColoredRGB('{ffffff}Старый {68E625}${ffffff}')
				imgui.SetCursorPos(imgui.ImVec2(78, 37)); imgui.PushItemWidth(sizeX - 99); imgui.InputText(u8'##newTextInput', newTextInput, sizeof(newTextInput)); imgui.PopItemWidth()
				imgui.SetCursorPos(imgui.ImVec2(24, 70)); imgui.TextColoredRGB('{ffffff}Новый {68E625}${ffffff}')
				imgui.SetCursorPos(imgui.ImVec2(78, 67)); imgui.PushItemWidth(sizeX - 99); imgui.InputText(u8'##newTextUpdInput', newTextUpdInput, sizeof(newTextUpdInput)); imgui.PopItemWidth()
	
				imgui.SetCursorPos(imgui.ImVec2(20, sizeY - 45))
				if imgui.Button(u8'Редактировать', imgui.ImVec2(sizeX/2 - 23, 25)) then
					editList[idNew].old_text = u8:decode(str(newTextInput))
					editList[idNew].new_text = u8:decode(str(newTextUpdInput))
					editList[idNew].date = os.date('%Y.%m.%d %X')

					--table.sort(editList, function(a,b) return a.date > b.date end)
					json(editJson):write(editList)
					imgui.CloseCurrentPopup()
					newTextInput, newTextUpdInput = new.char[256](''), new.char[256]('')
				end
				imgui.SameLine()
				--
				if imgui.Button(u8'Закрыть', imgui.ImVec2(sizeX/2 - 23, 25)) then
					imgui.CloseCurrentPopup()
				end
				imgui.EndPopup()
			end
			if imgui.BeginPopupModal(u8'Удаление готового объявления | LSN-Helper '..thisScript().version, _, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
				local pSize = imgui.ImVec2(900, 160)
				imgui.SetWindowSizeVec2(pSize)
		
				imgui.SetCursorPos(imgui.ImVec2(20, 40))
				imgui.TextColoredRGB('{ffffff}Старый {68E625}$ {ffffff}'..delText)

				imgui.SetCursorPos(imgui.ImVec2(20, 55))
				imgui.TextColoredRGB('{ffffff}Новый {68E625}$ {ffffff}'..delNewText)
					
				imgui.SetCursorPos(imgui.ImVec2(20, 80))
				imgui.Text(u8'Вы точно хотите это удалить?')
	
				imgui.SetCursorPos(imgui.ImVec2(20, pSize.y - 45))
				local but = imgui.ImVec2((pSize.x/2) - 23, 25)
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.77, 0.33, 1.0))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.2, 0.77, 0.33, 0.9))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.77, 0.33, 0.8))
				if imgui.Button(u8'Да', but) then
					table.remove(editList, idDel)
					--table.sort(editList, function(a,b) return a.date > b.date end)
					json(editJson):write(editList)
					imgui.CloseCurrentPopup()
				end
				imgui.PopStyleColor(3)
				imgui.SameLine()
				--
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 0.25, 0.25, 1.0))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.25, 0.25, 0.9))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(1.00, 0.25, 0.25, 0.8))
				if imgui.Button(u8'Нет', but) then
					imgui.CloseCurrentPopup()
				end
				imgui.PopStyleColor(3)
				imgui.EndPopup()
			end
			imgui.EndChild()

			imgui.SetCursorPos(imgui.ImVec2(sizeX/2 + 165, 5))
			local smbutt = imgui.ImVec2(sizeX/3 - 20, 24)

			if imgui.Button(u8'Создать готовое объявление', smbutt) then
				imgui.OpenPopup(u8'Создание готового объявления | LSN-Helper '..thisScript().version)
				newTextInput = new.char[256]('')
				newTextUpdInput = new.char[256]('')
			end
			if imgui.BeginPopupModal(u8'Создание готового объявления | LSN-Helper '..thisScript().version, _, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse) then
				local sizeX, sizeY = 800, 155; local vecs = imgui.ImVec2(sizeX, sizeY); imgui.SetWindowSizeVec2(vecs)

				imgui.SetCursorPos(imgui.ImVec2(20, 40)); imgui.TextColoredRGB('{ffffff}Старый {68E625}${ffffff}')
				imgui.SetCursorPos(imgui.ImVec2(78, 37)); imgui.PushItemWidth(sizeX - 99); imgui.InputText(u8'##newTextInput', newTextInput, sizeof(newTextInput)); imgui.PopItemWidth()
				imgui.SetCursorPos(imgui.ImVec2(24, 70)); imgui.TextColoredRGB('{ffffff}Новый {68E625}${ffffff}')
				imgui.SetCursorPos(imgui.ImVec2(78, 67)); imgui.PushItemWidth(sizeX - 99); imgui.InputText(u8'##newTextUpdInput', newTextUpdInput, sizeof(newTextUpdInput)); imgui.PopItemWidth()

				imgui.SetCursorPos(imgui.ImVec2(20, sizeY - 45))
				if imgui.Button(u8'Создать', imgui.ImVec2(sizeX/2 - 23, 25)) then
					local list = {
						date = os.date('%Y.%m.%d %X'),
						player = 'Script Helper',
						old_text = u8:decode(str(newTextInput)),
						new_text = u8:decode(str(newTextUpdInput))
					}
					table.insert(editList, list)
					table.sort(editList, function(a,b) return a.date > b.date end)
					json(editJson):write(editList)
					imgui.CloseCurrentPopup()
					newTextInput, newTextUpdInput = new.char[256](''), new.char[256]('')
				end
				imgui.SameLine()
				--
				if imgui.Button(u8'Закрыть', imgui.ImVec2(sizeX/2 - 23, 25)) then
					imgui.CloseCurrentPopup()
				end

				imgui.EndPopup()
			end

		elseif tab[0] == 3 then -- Раздел "Логи"
			imgui.SetCursorPos(imgui.ImVec2(5, 8))
			imgui.Text(u8'Поиск:')

			imgui.SetCursorPos(imgui.ImVec2(50, 5))
			imgui.PushItemWidth(sizeX - 65)
			if imgui.IsWindowAppearing() then imgui.SetKeyboardFocusHere(-1) end
			imgui.PushAllowKeyboardFocus(false)
			if imgui.InputText('##searchLog', searchLog, sizeof(searchLog)) then str(searchLog):find(str(searchLog):gsub("%p", "%%%1")) end
			imgui.PopAllowKeyboardFocus()
			imgui.PopItemWidth()

			imgui.SetCursorPos(imgui.ImVec2(5, 33))
			imgui.BeginChild('ChildWindowsS', imgui.ImVec2(sizeX/2 + 460, sizeY/2 + 92), true)

			local sbutt = imgui.ImVec2(50, 15)
			for i=1, #logList do
				if string.len(str(searchLog)) ~= 0 then
					if	string.find(u8(logList[i].text), str(searchLog), 1, true) or
						string.find(u8(logList[i].employee), str(searchLog), 1, true) or
						string.find(u8(logList[i].date), str(searchLog), 1, true) then
						imgui.Columns(2)
						if imgui.Selectable(u8'COPY##'..tonumber(i), true, _, sbutt) then
							local clipboard = ('['..logList[i].date..'] '..logList[i].text..'\n['..logList[i].date..'] '..logList[i].employee)
							setClipboardText(clipboard)
							send('Скопировано 2 строка, чтобы вставить нажмите CTRL + V')
						end

						if imgui.Selectable(u8'/RB [Тек]##'..tonumber(i), true, _, sbutt) then
							sampSendChat('/rb << Логи ['..tostring(i)..'] >> '..logList[i].text)
						end

						if imgui.Selectable(u8'/RB [Сот]##'..tonumber(i), true, _, sbutt) then
							sampSendChat('/rb << Логи ['..tostring(i)..'] >> '..logList[i].employee)
						end

						imgui.SetColumnWidth(0, 60)
						imgui.NextColumn()
						imgui.TextDisabled(u8('Дата: '..logList[i].date))
						imgui.Text(u8(logList[i].text))
						imgui.Text(u8(logList[i].employee))
						imgui.NextColumn()
						imgui.Separator()
					end
				else
					imgui.Columns(2)
					if imgui.Selectable(u8'COPY##'..tonumber(i), true, _, sbutt) then
						local clipboard = ('['..logList[i].date..'] '..logList[i].text..'\n['..logList[i].date..'] '..logList[i].employee)
						setClipboardText(clipboard)
						send('Скопировано 2 строка, чтобы вставить нажмите CTRL + V')
					end
	
					if imgui.Selectable(u8'/RB [Тек]##'..tonumber(i), true, _, sbutt) then
						sampSendChat('/rb << Логи ['..tostring(i)..'] >> '..logList[i].text)
					end
	
					if imgui.Selectable(u8'/RB [Сот]##'..tonumber(i), true, _, sbutt) then
						sampSendChat('/rb << Логи ['..tostring(i)..'] >> '..logList[i].employee)
					end
	
					imgui.SetColumnWidth(0, 60)
					imgui.NextColumn()
					imgui.TextDisabled(u8('Дата: '..logList[i].date))
					imgui.Text(u8(logList[i].text))
					imgui.Text(u8(logList[i].employee))
					imgui.NextColumn()
					imgui.Separator()
				end
			end
		end
		imgui.EndChild()
		imgui.End()
	end
)

function main()
	while not isSampAvailable() do wait(0) end

	if not doesFileExist(editJson) then json(editJson):write({}) end; editList = json(editJson):read()
	if not doesFileExist(adJson) then json(adJson):write({}) end; adList = json(adJson):read()
	if not doesFileExist(logJson) then json(logJson):write({}) end; logList = json(logJson):read()

	send('Скрипт успешно загружено. Версия: '..thisScript().version..'. Команда: /lsn_menu')
	print(); print('Script LSN-Helper '..thisScript().version..' loaded - Discord: kyrtion#7310')

	-- --! debug window (dont use)
	-- sampRegisterChatCommand('ef', function()
		-- renderWindow[0] = not renderWindow[0]
		-- imgui.StrCopy(adInput, u8(adText))
	-- end)

	sampRegisterChatCommand('lsn_verify', function()
		if lockVerify then
			if renderWindow[0] or sampIsDialogActive() then			
				send('Закройте диалог и снова вводите /lsn_verify')
			else
				checkVerify = true
				send('Обновляю '..oldVersion ..' -> '..newVersion..' ...')
				lockVerify = false
			end
		end
	end)

	sampRegisterChatCommand('lsn_menu', function()
		if not renderWindow[0] then menuWindow[0] = not menuWindow[0] else send('Сначала заканчивайте с объявлением, затем внов вводите повторно команды') end
	end)

	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			updateIni = inicfg.load(nil, update_path)
			if tostring(updateIni.info.version) or tostring(updateIni.info) or tostring(updateIni) ~= (nil or '') then
				newVersion = tostring(updateIni.info.version):gsub('"', '')
				oldVersion = tostring(thisScript().version)
				if newVersion ~= oldVersion then
					send('Есть обновление! Версия: '..newVersion..'. Чтобы обновить вводите /lsn_verify')
					update_state = true
					lockVerify = true
				end
				os.remove(update_path)
			else
				send('Невозможно проверить наличие обновление. Нажмите CTRL + R чтобы перезагрузить')
			end
		end
	end)
	
	while true do
		wait(0)
		if update_state and checkVerify then
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					send('Скрипт успешно обновлен! Сейчас будет перезагружен')
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
		if (wparam == VK_ESCAPE and (renderWindow[0] or menuWindow[0])) and not isPauseMenuActive() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
			consumeWindowMessage(true, false)
		end
	end
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
	if id == 1536 and title == '{6333FF}Публикация объявления' then
		if notAdNick then
			adNick = ( text:match('%{ffffff%}Отправитель%: %{7FFF00%}(%w+ %w+)') ):gsub('\n', '')
			notAdNick = false
			send('Вы не обновили актуальный диалог для редактирования объявление, ID отправителя не будет показан.')
			send('В следующий раз когда появится сообщение /edit, вводите команды только без диалога!')
		end
		adText = ( text:match('%{ffffff%}Текст%:%{7FFF00%} (.*)%{ffffff%}') ):gsub('\n', '')
		adPrice = ( text:match('%{ffffff%}Цена%:%{7FFF00%} (.*)%{FFFFFF%}') ):gsub('\n', '')
		renderWindow[0] = true
		for i=1, #editList do
			if editList[i].old_text == adText then
				imgui.StrCopy(adInput, u8(editList[i].new_text))
				copying = true
				break
			end
		end
		if not copying then
			imgui.StrCopy(adInput, u8(adText))
		end
		return false

	elseif id == 1537 and title == '{6333FF}Публикация объявления: {ffffff}Подтверждение' and confirm then
		sampSendDialogResponse(1537, 1, 0, 0)
		confirm = false
		return false
	end
end

function sampev.onSendDialogResponse(dialogId, button, listboxId, text)
	if dialogId == 1000 and button == 1 then
		if text:find('-') then
			notAdNick = true
		else
			local fr = ''; fr, adNick = text:match('(%d+)%. (.*)')
			notAdNick = false
		end
	end
end

local adStringText = ''
local adStringEtc = ''
local adStringEmployee = ''
local adLockText = false
local adLockEtc = false

local newsStringText = ''
local newsLockText = false

function sampev.onServerMessage(color, text)
	if color == 2147418282 then
		if text:find('новое объявление на проверку') then
			--printStyledString('/edit', 5000, 4)
			send(text)
			return false
		elseif text:find('запросил отказ на публикацию') then
			send(text)
			return false
		end
	end

	if color == -1616928769 and (text == 'Подсказка: Чтобы открыть инвентарь, нажмите \'Y\'' or
								 text == 'Подсказка: Чтобы взаимодействовать с ботом/игроком, нажмите \'пр. кнопка мыши\' + \'H\'' or
								 text == 'Подсказка: Чтобы открыть багажник машины, нажмите \'пр. кнопка мыши\' + \'Прыжок\'' or
								 text == 'Подсказка: Вы можете отключить помощь в /mm -> настройки'
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
		text = text:gsub('%{......%}', '')
		send(text)
		
		lua_thread.create(function()
			wait(0)
			sampSendChat('/edit')
		end)

		return false
	end

	if color == -1 and (text:find('Вы отклонили объявление') or text:find('Тот, кто подал объявление, покинул сервер')) then
		send(text)
		return false
	end

	-- if newsLockText and not text:find('%{......%}') then
	-- 	if color == (-453656577 or -453656662) then
	-- 		newsStringText = newsStringText..text
	-- 		sampAddChatMessage(newsStringText, -1)
	-- 	else
	-- 		sampAddChatMessage(newsStringText, -1)
	-- 	end

	-- 	local list = {
	-- 		type = 'news',
	-- 		date = os.date('%Y.%m.%d %X'),
	-- 		text = adStringText,
	-- 		employee = adStringEmployee
	-- 	}
	-- 	table.insert(logList, list)
	-- 	table.sort(logList, function(a,b) return a.date > b.date end)
	-- 	json(logJson):write(logList)

	-- 	newsLockText = false
	-- end

	-- if color == (-453656577 or -453656662) and text:find('%{BDDE76%}%[Los Santos News%]') then
	-- 	newsStringText = text
	-- 	newsLockText = true
	-- end

	if adLockText then
		if color == 2147418282 and not text:find('Объявление проверил работник: (.+)%[(%d+)%]$') then
			adStringEtc = text
			adLockEtc = true
			return false
		end
	end

	if color == 2147418282 and text:find('%[News Studio%]') then
		adStringText = text:gsub('%[News Studio%]%s', '')
		adLockText = true
		return false
	elseif color == 2147418282 and text:find('Объявление проверил работник: (.+)%[(%d+)%]$') then
		adStringEmployee = text:gsub('    ', '') -- увы это не табуляция, а 4 пробелы, разраб мх просто гений
		if adLockEtc then
			local tempText, adChar = adStringText:match('(.*)(%p)$')
			if adChar == '-' then
				adStringText = tempText..adStringEtc
			else
				adStringText = adStringText..adStringEtc
			end
		end
		sampAddChatMessage(adStringText, 0x48AB71)
		sampAddChatMessage(adStringEmployee, 0x48AB71)

		local list = {
			type = 'ad',
			date = os.date('%Y.%m.%d %X'),
			text = adStringText,
			employee = adStringEmployee
		}
		table.insert(logList, list)
		table.sort(logList, function(a,b) return a.date > b.date end)
		json(logJson):write(logList)

		adStringText, adStringEtc, adStringEmployee = '', '', ''
		adLockText, adLockEtc = false, false
		return false
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
	imgui.GetStyle().WindowBorderSize = 3
	imgui.GetStyle().ChildBorderSize = 2
	imgui.GetStyle().PopupBorderSize = 3
	imgui.GetStyle().FrameBorderSize = 2
	imgui.GetStyle().TabBorderSize = 1

	--==[ ROUNDING ]==--
	imgui.GetStyle().WindowRounding = 4
	imgui.GetStyle().ChildRounding = 3
	imgui.GetStyle().FrameRounding = 3
	imgui.GetStyle().PopupRounding = 4
	imgui.GetStyle().ScrollbarRounding = 4
	imgui.GetStyle().GrabRounding = 4
	imgui.GetStyle().TabRounding = 4

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
		if not lockFailed then
			send('Что-то пошло не так с скриптом... Отключаем, чтобы перезагрузить нажми CTRL + R')
		end
		return true
	end
end
