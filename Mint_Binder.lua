require "lib.moonloader"
require 'lib.sampfuncs'
local imgui = require 'imgui'
local encoding = require "encoding"
local inicfg = require 'inicfg'
--local fa = require 'fAwesome5'
encoding.default = 'CP1251'
u8 = encoding.UTF8
sw,sh = getScreenResolution()
local activator = imgui.ImBool(false)


local directIni = "MintScripts\\MintBinder\\main.ini"


if not doesDirectoryExist('moonloader/config') then createDirectory("moonloader/config") end
if not doesDirectoryExist('moonloader/config/MintScripts') then createDirectory ("moonloader/config/MintScripts") end
if not doesDirectoryExist('moonloader/config/MintScripts/MintBinder') then createDirectory ("moonloader/config/MintScripts/MintBinder") end


local def = {
	settings = {
		cmdactivate = "start",
	},

	delays = {
		1000,
		1000,
	},

	times = {
		'00:00:00',
		'00:00:00',
	},

	enables = {
		false,
		false,
	},


}







local ini = inicfg.load(def, directIni)


function saveBind(key,text)
	local saveCFG = io.open('moonloader/config/MintScripts/MintBinder/bind_'..key..'.txt', "w")
	if saveCFG then
		saveCFG:write(text)
		saveCFG:close()
	end
  end


if not doesFileExist('moonloader/config/MintScripts/MintBinder/main.ini') then inicfg.save(def, directIni) end
buffers = {}
for k,v in pairs(ini.delays) do 
	if not doesFileExist('moonloader/config/MintScripts/MintBinder/bind_'.. k..'.txt') then
		saveBind(k,"")
		table.insert(buffers,imgui.ImBuffer("",1000))
	else 
		local f = io.open('moonloader/config/MintScripts/MintBinder/bind_'.. k..'.txt', "r")
		if f then
			table.insert(buffers,imgui.ImBuffer(f:read("a*"),1000))
			f:close()
		end
	end
end






enables = {}
for k,v in pairs(ini.enables) do
	table.insert(enables,imgui.ImBool(v))
end

times = {}
for k,v in pairs(ini.times) do 
	table.insert(times,imgui.ImBuffer(v,300))
end

delays = {}
for k,v in pairs(ini.delays) do 
	table.insert(delays,imgui.ImInt(v))
end


bools = {}
for k,v in pairs(ini.enables) do 
	table.insert(bools,false)
end

local cmdactivate = imgui.ImBuffer(ini.settings.cmdactivate,32);






function main()
	while not isSampAvailable() do wait(0) end
	sampAddChatMessage('{19ff19}[Mint-Binder]{FFFFFF} Скрипт успешно запущен. Команда активации: {F6361C}/'.. cmdactivate.v,-1)
	sampRegisterChatCommand(cmdactivate.v,function()
		activator.v = not activator.v
	end)
	
	while true do
		wait(0)
		imgui.Process = activator.v

		for k,v in pairs(times) do
		  if not bools[k] then   
				if v.v == os.date("%X",os.time()) then
					bools[k] = true
					goMessage(k)
				end
			end
		end
	end
end


function imgui.OnDrawFrame()
	if activator.v then
		imgui.SetNextWindowSize(imgui.ImVec2(700, 450), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
		imgui.Begin(u8'Биндер', activator,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove)
		imgui.InputText(u8'Команда Активации',cmdactivate)
		if imgui.Button(u8'Сохранить команду') then 
			sampUnregisterChatCommand(ini.settings.cmdactivate) 
			ini.settings.cmdactivate = cmdactivate.v 
			save()
			sampRegisterChatCommand(cmdactivate.v,function() activator.v = not activator.v end) 
			sampAddChatMessage("{19ff19}[Mint-Binder] {FFFFFF}Новая команда активации: {F6361C}/".. cmdactivate.v,-1)
		end

		imgui.SameLine()
		if imgui.Button(u8'Добавить бинд') then
			
			myIndex = 0
			abc = 1
			while abc == 1 do
			myIndex = myIndex + 1
			if ini.delays[myIndex] == nil then abc = 2 end
		end

		table.insert(buffers,imgui.ImBuffer("",1000))
		table.insert(delays,imgui.ImInt(3030))
		table.insert(times,imgui.ImBuffer('00:00:00'))
		ini.delays[myIndex] = 1000
		ini.enables[myIndex] = false
		ini.times[myIndex] = '00:00:00'
		bools[myIndex] = false
		saveBind(myIndex,"")
		save()

 
		end
			for k,v in pairs(ini.delays) do
			imgui.BeginChild(u8"##a"..k,imgui.ImVec2(672,200),true,imgui.WindowFlags.NoScrollbar)
			if imgui.Checkbox(u8'Статус активности##'..k,enables[k]) then ini.enables[k] = enables[k].v save()  end
			imgui.SameLine()
			if imgui.CustomSlider(u8'Заддержка между сообщениями##'..k,0,3030,100,delays[k]) then ini.delays[k] = delays[k].v save() end
			imgui.Hint(u8'Заддержка между отправкой сообщений указывается в милисекундах. По умолчанию - 1000 мс (1 секунда)')
			if imgui.InputText(u8'Время отправки##'..k,times[k]) then ini.times[k] = times[k].v  end
				if imgui.InputTextMultiline('##'..k,buffers[k],imgui.ImVec2(667,100)) then
					saveBind(k,buffers[k].v)
					
					
				end

			if imgui.Button(u8"Удалить") then
				ini.delays[k] = nil
				ini.enables[k] = nil   
				ini.times[k] = nil
				bools[myIndex] = nil
				save()   
				os.remove('moonloader/config/MintScripts/MintBinder/bind_'.. k..'.txt')
			end
			imgui.EndChild()
			end
		imgui.End()
	end
end



function goMessage(key)
	if enables[key].v or buffers[key].v ~= nil or delays[key].v ~= nil then
		multiStringSendChat(delays[key].v, u8:decode(buffers[key].v), key)
	else 
		sampAddChatMessage('{F6361C}[Ошибка]{FFFFFF} Какой-то из параметров не указан, ищите ошибку в #'..key..' бинде.', -1)
	end
end

function multiStringSendChat(delay, multiStringText, key)   
	lua_thread.create(function()
		multiStringText = multiStringText..'\n'
		for s in multiStringText:gmatch('.-\n') do
			sampSendChat(s)
			wait(delay)
		end
		wait(1000)
		bools[key] = false
	end)
end





function imgui.CustomSlider(str_id, min, max, width, int)
	local p = imgui.GetCursorScreenPos()
	local draw_list = imgui.GetWindowDrawList()
	local pos = imgui.GetWindowPos()
	local posx, posy = getCursorPos()
	local n = max - min
	if int.v == 0 then
		int.v = min
	end
	local col_bg_active = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ButtonActive])
	local col_bg_notactive = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ModalWindowDarkening])
	draw_list:AddRectFilled(imgui.ImVec2(p.x + 7, p.y + 12), imgui.ImVec2(p.x + (width/n)*(int.v-min), p.y + 12), col_bg_active, 5.0)
	draw_list:AddRectFilled(imgui.ImVec2(p.x + (width/n)*(int.v-min), p.y + 12), imgui.ImVec2(p.x + width, p.y + 12), col_bg_notactive, 5.0)
	for i = 0, n do
		if posx > (p.x + i*width/(max+1) ) and posx < (p.x + (i+1)*width/(max+1)) and posy > p.y + 2 and posy < p.y + 22 and imgui.IsMouseDown(0) then
			int.v = i + min
			draw_list:AddCircleFilled(imgui.ImVec2(p.x + (width/n)*(int.v-min) + 4, p.y + 7*2 - 2), 7+2, col_bg_active)
		end
	end
	imgui.SetCursorPos(imgui.ImVec2(p.x + width + 6 - pos.x, p.y - 8 - pos.y))
	imgui.Text(tostring(int.v))
	draw_list:AddCircleFilled(imgui.ImVec2(p.x + (width/n)*(int.v-min) + 4,  p.y + 7*2 - 2), 7, col_bg_active)
	imgui.NewLine()
	return int
end





function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0

	colors[clr.FrameBg]                = ImVec4(0.42, 0.48, 0.16, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.85, 0.98, 0.26, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.85, 0.98, 0.26, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.42, 0.48, 0.16, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.CheckMark]              = ImVec4(0.85, 0.98, 0.26, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.77, 0.88, 0.24, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.85, 0.98, 0.26, 1.00)
	colors[clr.Button]                 = ImVec4(0.85, 0.98, 0.26, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.85, 0.98, 0.26, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.82, 0.98, 0.06, 1.00)
	colors[clr.Header]                 = ImVec4(0.85, 0.98, 0.26, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.85, 0.98, 0.26, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.85, 0.98, 0.26, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.63, 0.75, 0.10, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.63, 0.75, 0.10, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.85, 0.98, 0.26, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.85, 0.98, 0.26, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.85, 0.98, 0.26, 0.95)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.81, 0.35, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.85, 0.98, 0.26, 0.35)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end


apply_custom_style()


function save()
	inicfg.save(def,directIni);
end


function imgui.Hint(text, delay)
	if imgui.IsItemHovered() then
		if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
		local alpha = (os.clock() - go_hint) * 5 -- скорость появления
		if os.clock() >= go_hint then
			imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
				imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.ButtonHovered])
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(450)
					imgui.TextUnformatted(text)
					if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
					imgui.PopTextWrapPos()
					imgui.EndTooltip()
				imgui.PopStyleColor()
			imgui.PopStyleVar()
		end
	end
  end




