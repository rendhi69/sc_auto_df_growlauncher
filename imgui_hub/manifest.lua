-- ============================================================================
-- BOREN STORE - DEDICATED FEATURE MANIFEST (DIRT FARM)
-- File: imgui_hub/manifest.lua
-- Repo: https://github.com/rendhi69/sc_auto_df_growlauncher.git
-- ============================================================================

return {
    schema = "boren_gl_manifest_v1",
    core = {
        { key = "conn", path = "imgui_hub/conn_guard.lua", required = false },
    },
    features = {
        { id = "dirt_farm", label = "Dirt Farm", order = 20, path = "imgui_hub/mod_dirt_farm.lua" },
    },
}
