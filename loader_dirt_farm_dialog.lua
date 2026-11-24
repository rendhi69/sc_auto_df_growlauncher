-- ============================================================================
-- LOADER BOREN STORE - AUTO DIRT FARM (FULL IN-GAME DIALOG)
-- File: loader_dirt_farm_dialog.lua
-- Repo: https://github.com/rendhi69/sc_auto_df_growlauncher
-- ============================================================================
-- 100% In-Game Growtopia Dialog murni (OnDialogRequest / action|dialog_return).
-- ONLINE-FIRST: Selalu mengambil pembaruan skrip langsung dari GitHub / CDN resmi.
-- Dilengkapi multi-fallback (jsDelivr CDN + GitHub raw) bebas blokir ISP.
-- Jika offline atau fetch gagal, otomatis fallback memuat file lokal perangkat.
-- Dilengkapi Fast Interceptor agar /df & /dirtfarm tidak pernah 'Unknown command'.
-- ============================================================================

local function logMsg(msg)
    if LogToConsole then pcall(LogToConsole, "`5[BOREN DF LOADER] `w" .. tostring(msg)) end
end

local function notifyUser(msg)
    if sendNotification then pcall(sendNotification, tostring(msg))
    elseif growtopia and growtopia.notify then pcall(growtopia.notify, tostring(msg)) end
end

local function makeAntiCacheTag()
    local t = ""
    if getTime then
        local ok, ms = pcall(getTime)
        if ok and tonumber(ms) then t = tostring(math.floor(tonumber(ms))) end
    end
    if t == "" and os and os.time then
        local ok, s = pcall(os.time)
        if ok and tonumber(s) then t = tostring(math.floor(tonumber(s))) end
    end
    if t == "" then
        t = tostring(math.random(100000, 999999))
    end
    return t
end

-- ============================================================================
-- FAST CHAT INTERCEPTOR DI TINGKAT LOADER (/df, /dirtfarm, /farm)
-- Mencegah munculnya 'Unknown command' di chat game sejak detik pertama
-- ============================================================================
local function loaderFastPacketHook(arg1, arg2)
    local pStr = nil
    local pType = nil
    if type(arg1) == "string" then
        pStr = arg1
        pType = (type(arg2) == "number") and arg2 or nil
    elseif type(arg2) == "string" then
        pStr = arg2
        pType = (type(arg1) == "number") and arg1 or nil
    elseif type(arg1) == "table" then
        pStr = arg1.str or arg1.packet or arg1.text or arg1.data or arg1[2] or arg1[1]
        pType = tonumber(arg1.type)
    elseif type(arg2) == "table" then
        pStr = arg2.str or arg2.packet or arg2.text or arg2.data or arg2[2] or arg2[1]
        pType = tonumber(arg2.type)
    end

    if not pStr or type(pStr) ~= "string" then return false end

    -- Intersepsi Chat Command /df, /dirtfarm, /farm, /dfarm, /boren, /menu
    local lowerP = pStr:lower()
    if lowerP:find("/df", 1, true) or lowerP:find("/dirtfarm", 1, true) or lowerP:find("/farm", 1, true) or lowerP:find("/dfarm", 1, true) or lowerP:find("/boren", 1, true) or lowerP:find("/menu", 1, true) then
        if lowerP:find("action|input", 1, true) or lowerP:find("text|/", 1, true) or lowerP:find("action|chat", 1, true) or lowerP:sub(1, 1) == "/" then
            local cmd = lowerP:match("|text|(/[a-z0-9_]+)") or lowerP:match("text|(/[a-z0-9_]+)") or lowerP:match("(/[a-z0-9_]+)")
            if cmd == "/df" or cmd == "/dirtfarm" or cmd == "/farm" or cmd == "/dfarm" or cmd == "/boren" or cmd == "/menu" then
                local openFn = _G.showDFMainDialog or showDFMainDialog
                if openFn then
                    pcall(openFn)
                    logMsg("`2Menu Dialog DF dibuka via chat: `e" .. tostring(cmd))
                else
                    notifyUser("Auto Dirt Farm sedang dimuat... ketik /df lagi sebentar!")
                end
                return true -- SELALU BLOKIR agar tidak muncul Unknown command di server!
            end
        end
    end

    -- Intersepsi Dialog Return
    if pStr:find("action|dialog_return", 1, true) then
        local dn = pStr:match("dialog_name|([^\r\n]+)")
        if dn and dn:sub(1, 3) == "df_" then
            local handler = _G.handleDFDialogReturn or handleDFDialogReturn
            if handler then
                pcall(handler, pStr)
                return true
            end
        end
    end

    return false
end

-- Pasang Fast Hook ke semua varian hook engine Growlauncher
local hookFuncs = { addHook, AddHook, hook, Hook }
for _, h in ipairs(hookFuncs) do
    if type(h) == "function" then
        pcall(h, loaderFastPacketHook, "onsendpacket")
        pcall(h, loaderFastPacketHook, "onSendPacket")
        pcall(h, loaderFastPacketHook, "OnSendPacket")
        pcall(h, "onsendpacket", loaderFastPacketHook)
        pcall(h, "onSendPacket", loaderFastPacketHook)
        pcall(h, "OnSendPacket", loaderFastPacketHook)
        pcall(h, "onsendpacket", "boren_df_loader_hook", loaderFastPacketHook)
        pcall(h, "onSendPacket", "boren_df_loader_hook", loaderFastPacketHook)
        pcall(h, "OnSendPacket", "boren_df_loader_hook", loaderFastPacketHook)
    end
end
if AddHookCallback then
    pcall(AddHookCallback, loaderFastPacketHook, "onsendpacket")
    pcall(AddHookCallback, loaderFastPacketHook, "onSendPacket")
    pcall(AddHookCallback, "onsendpacket", loaderFastPacketHook)
    pcall(AddHookCallback, "onSendPacket", loaderFastPacketHook)
end
onSendPacket = loaderFastPacketHook
OnSendPacket = loaderFastPacketHook
_G.onSendPacket = loaderFastPacketHook
_G.OnSendPacket = loaderFastPacketHook
if applyHook then pcall(applyHook) end
if ApplyHook then pcall(ApplyHook) end

-- ============================================================================
-- DAFTAR JALUR LOKAL PERANGKAT (PC & ANDROID)
-- ============================================================================
local current_dir = ""
if debug and debug.getinfo then
    local src = debug.getinfo(1, "S").source
    if src and src:sub(1, 1) == "@" then
        current_dir = src:sub(2):match([=[^(.*[/\])]=]) or ""
    end
end

local LOCAL_PATHS = {
    current_dir .. "auto_dirt_farm.lua",
    current_dir .. "../dialog/dirt farm/auto_dirt_farm.lua",
    "script/dialog/dirt farm/auto_dirt_farm.lua",
    "script/script done dont edit/sc dirt farm/auto_dirt_farm.lua",
    "script/script code/dirt farm/auto_dirt_farm.lua",
    "auto_dirt_farm.lua",
    "/storage/emulated/0/Android/media/launcher.powerkuy.growlauncher/ScriptLua/dialog/dirt farm/auto_dirt_farm.lua",
    "/storage/emulated/0/Android/media/launcher.powerkuy.growlauncher/ScriptLua/auto_dirt_farm.lua",
    "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/ScriptLua/dialog/dirt farm/auto_dirt_farm.lua",
    "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/ScriptLua/auto_dirt_farm.lua",
    "/storage/emulated/0/Download/auto_dirt_farm.lua",
}

-- ============================================================================
-- 1. PRIORITAS UTAMA: ONLINE-FIRST (CDN & GITHUB RAW RESMI)
-- ============================================================================
local ONLINE_URLS = {
    -- 1. GitHub Raw Langsung dengan Anti-Cache (Instant bypass semua cache)
    "https://raw.githubusercontent.com/rendhi69/sc_auto_df_growlauncher/main/auto_dirt_farm.lua?v=" .. makeAntiCacheTag(),
    "https://raw.githubusercontent.com/rendhi69/sc_auto_df_growlauncher/refs/heads/main/auto_dirt_farm.lua?v=" .. makeAntiCacheTag(),
    -- 2. jsDelivr CDN
    "https://cdn.jsdelivr.net/gh/rendhi69/sc_auto_df_growlauncher@main/auto_dirt_farm.lua",
    -- 3. GitHub Raw Standard
    "https://raw.githubusercontent.com/rendhi69/sc_auto_df_growlauncher/main/auto_dirt_farm.lua"
}

logMsg("`9Menghubungkan ke server untuk mengunduh Auto Dirt Farm Dialog terbaru...")
local fetcher = fetch or (http and http.get) or (client and client.fetch) or (growtopia and growtopia.fetch)
local content = nil
local fetchedSource = ""

if fetcher then
    for _, u in ipairs(ONLINE_URLS) do
        -- Coba URL bersih terlebih dahulu (tanpa query string agar libcurl/fetch tidak error)
        local okFetch, res = pcall(fetcher, u)
        if okFetch and res then
            if type(res) == "string" and #res > 500 then
                content = res
                fetchedSource = u
                break
            elseif type(res) == "table" and res.body and #res.body > 500 then
                content = res.body
                fetchedSource = u
                break
            end
        end

        -- Coba varian anti-cache jika URL bersih gagal
        local tag = makeAntiCacheTag()
        local okF2, res2 = pcall(fetcher, u .. "?t=" .. tag)
        if okF2 and res2 then
            if type(res2) == "string" and #res2 > 500 then
                content = res2
                fetchedSource = u
                break
            elseif type(res2) == "table" and res2.body and #res2.body > 500 then
                content = res2.body
                fetchedSource = u
                break
            end
        end
    end
end

if content and #content > 500 then
    logMsg("`2Berhasil mengunduh Auto Dirt Farm terbaru (" .. tostring(#content) .. " bytes)!")

    -- Simpan otomatis ke file lokal perangkat agar cache selalu sinkron dengan server
    for _, p in ipairs(LOCAL_PATHS) do
        if p and p ~= "" then
            local okW, fW = pcall(io.open, p, "w")
            if okW and fW then
                pcall(function() fW:write(content) end)
                pcall(function() fW:close() end)
            end
        end
    end

    local loaderFn = loadstring or load
    local chunk, err = loaderFn(content)
    if chunk then
        local okRun, rErr = pcall(chunk)
        if okRun then
            logMsg("`2[ONLINE] Auto Dirt Farm In-Game Dialog Berhasil Aktif!")
            notifyUser("`2[ONLINE] Auto Dirt Farm Siap! Ketik /df.")
            if _G.showDFMainDialog then pcall(_G.showDFMainDialog) end
            return
        else
            logMsg("`4Error runtime GitHub script: " .. tostring(rErr))
        end
    else
        logMsg("`4Error kompilasi GitHub script: " .. tostring(err))
    end
end

-- ============================================================================
-- 2. CADANGAN: JIKA SERVER ONLINE GAGAL / OFFLINE, FALLBACK KE FILE LOKAL
-- ============================================================================
logMsg("`4[PERINGATAN] Server online tidak merespon! Memuat cadangan file lokal...")
for _, p in ipairs(LOCAL_PATHS) do
    if p and p ~= "" then
        local okOpen, f = pcall(io.open, p, "r")
        if okOpen and f then
            local txt = f:read("*a")
            f:close()
            if txt and #txt > 100 then
                logMsg("`6Memuat skrip cadangan lokal: " .. tostring(p))
                local loaderFn = loadstring or load
                local chunk, err = loaderFn(txt)
                if chunk then
                    local okRun, rErr = pcall(chunk)
                    if okRun then
                        logMsg("`3[LOKAL] Auto Dirt Farm Cadangan Lokal Berhasil Aktif!")
                        notifyUser("`4[LOKAL] File lokal dimuat (Bukan online terbaru)!")
                        if _G.showDFMainDialog then pcall(_G.showDFMainDialog) end
                        return
                    else
                        logMsg("`4Error runtime lokal: " .. tostring(rErr))
                    end
                else
                    logMsg("`4Error kompilasi lokal: " .. tostring(err))
                end
            end
        end
    end
end

logMsg("`4Gagal memuat skrip dari server online maupun penyimpanan lokal!")
notifyUser("`4Gagal memuat Auto Dirt Farm Dialog!")
