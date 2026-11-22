-- ============================================================================
-- LOADER BOREN STORE - AUTO DIRT FARM PRO
-- ============================================================================
-- Mengambil dan menjalankan auto_dirt_farm.lua langsung dari GitHub:
-- https://github.com/rendhi69/sc_auto_df_growlauncher.git
-- ============================================================================

local RAW_URL = "https://raw.githubusercontent.com/rendhi69/sc_auto_df_growlauncher/main/auto_dirt_farm.lua"
local cacheBuster = tostring(math.floor((os and os.time and os.time()) or (os and os.clock and os.clock() * 1000) or math.random(100000, 999999)))
local fetchUrl = RAW_URL .. "?v=" .. cacheBuster

local function notifyUser(msg)
    if sendNotification then pcall(sendNotification, tostring(msg))
    elseif growtopia and growtopia.notify then pcall(growtopia.notify, tostring(msg)) end
end

local function logMsg(msg)
    if LogToConsole then pcall(LogToConsole, "`e[Dirt Farm] `0" .. tostring(msg)) end
end

logMsg("Menghubungkan ke GitHub dan memuat auto_dirt_farm.lua...")
notifyUser("Memuat BOREN STORE - AUTO DIRT FARM PRO...")

local content = nil
if fetch then
    local okFetch, res = pcall(fetch, fetchUrl)
    if okFetch and type(res) == "string" and res ~= "" and not res:match("^404") and not res:match("^<!DOCTYPE") then
        content = res
    end
end

if not content or content == "" then
    local localCandidates = {
        "/storage/emulated/0/Android/media/launcher.powerkuy.growlauncher/ScriptLua/auto_dirt_farm.lua",
        "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/ScriptLua/auto_dirt_farm.lua",
        "/storage/emulated/0/Download/auto_dirt_farm.lua",
        "script/auto_dirt_farm.lua",
        "auto_dirt_farm.lua",
    }
    for _, p in ipairs(localCandidates) do
        local okF, fh = pcall(io.open, p, "r")
        if okF and fh then
            local text = fh:read("*a")
            fh:close()
            if text and text ~= "" then
                content = text
                logMsg("Memuat skrip dari file lokal: " .. p)
                break
            end
        end
    end
end

if not content or content == "" then
    logMsg("`4Gagal memuat auto_dirt_farm.lua! Periksa koneksi internet / file lokal.")
    notifyUser("Gagal load skrip!")
    return
end

local loaderFn = loadstring or load
local chunk, err = loaderFn(content)
if not chunk then
    logMsg("`4Error kompilasi script: " .. tostring(err))
    notifyUser("Syntax error!")
    return
end

logMsg("`2BOREN STORE - AUTO DIRT FARM PRO berhasil dimuat!")
notifyUser("Dirt Farm Siap Digunakan!")
chunk()
