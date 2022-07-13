-- by Cosmo with <3
local ffi = require "ffi"
local ini = require "inicfg"
local memory = require "memory"

local cfg = ini.load({ main = { x = 30, y = 400 } }, "clock.ini")
local font_big = renderCreateFont("Ubuntu", 15, 5)
local font_low = renderCreateFont("Calibri", 10, 5)

ffi.cdef[[
    typedef unsigned short WORD;

    typedef struct _SYSTEMTIME {
        WORD wYear;
        WORD wMonth;
        WORD wDayOfWeek;
        WORD wDay;
        WORD wHour;
        WORD wMinute;
        WORD wSecond;
        WORD wMilliseconds;
    } SYSTEMTIME, *PSYSTEMTIME;

    void GetLocalTime(
        PSYSTEMTIME lpSystemTime
    );
]]

function main()
    repeat wait(0) until isSampAvailable()
    sampRegisterChatCommand("clockpos", function()
        lua_thread.create(function()
            showCursor(true, true)
            while not isKeyJustPressed(0x01) do
                cfg.main.x, cfg.main.y = getCursorPos()
                printStringNow(cyrillic("~w~Нажмите ~y~ЛКМ~w~ чтобы сохранить!"), 100)
                wait(0)
            end
            while isKeyDown(0x01) do wait(0) end
            if ini.save(cfg, "clock.ini") then
                printStringNow(cyrillic("~w~Успешно сохранено!"), 2000)
            end
            showCursor(false, false)
        end)
    end)
    wait(-1)
end

function onD3DPresent()
    if memory.getint8(0xBA6769) == 1 then -- HUD is visible
        local time = ffi.new("SYSTEMTIME")
        ffi.C.GetLocalTime(time)

        local str_clock = string.format("%02d:%02d:%02d", time.wHour, time.wMinute, time.wSecond)
        local len_clock = renderGetFontDrawTextLength(font_big, str_clock)
        local str_date = getStrDate(time)

        local X, Y = cfg.main.x, cfg.main.y
        local str_ms = string.format(".%02d", time.wMilliseconds / 10) 
        renderFontDrawText(font_big, str_clock, X, Y, 0xFFEEEEEE)
        renderFontDrawText(font_low, str_ms, X + len_clock, Y + 9, 0xAAEEEEEE)
        renderFontDrawText(font_low, str_date, X, Y + 25, 0xFF80FF80)
    end
end

function getStrDate(sTime)
    local tWeekdays = {[0] = "Воскресенье", [1] = "Понедельник", [2] = "Вторник", [3] = "Среда", [4] = "Четверг", [5] = "Пятница", [6] = "Суббота"}
    local tMonths = {"января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"}
    
    local weekday = tWeekdays[sTime.wDayOfWeek]
    local month = tMonths[sTime.wMonth]
    return string.format("%s, %s %s", weekday, sTime.wDay, month)
end

function cyrillic(text)
    local convtbl = {[230]=155,[231]=159,[247]=164,[234]=107,[250]=144,[251]=168,[254]=171,[253]=170,[255]=172,[224]=97,[240]=112,[241]=99,[226]=162,[228]=154,[225]=151,[227]=153,[248]=165,[243]=121,[184]=101,[235]=158,[238]=111,[245]=120,[233]=157,[242]=166,[239]=163,[244]=63,[237]=174,[229]=101,[246]=36,[236]=175,[232]=156,[249]=161,[252]=169,[215]=141,[202]=75,[204]=77,[220]=146,[221]=147,[222]=148,[192]=65,[193]=128,[209]=67,[194]=139,[195]=130,[197]=69,[206]=79,[213]=88,[168]=69,[223]=149,[207]=140,[203]=135,[201]=133,[199]=136,[196]=131,[208]=80,[200]=133,[198]=132,[210]=143,[211]=89,[216]=142,[212]=129,[214]=137,[205]=72,[217]=138,[218]=167,[219]=145}
    local result = {}
    for i = 1, #text do
        local c = text:byte(i)
        result[i] = string.char(convtbl[c] or c)
    end
    return table.concat(result)
end