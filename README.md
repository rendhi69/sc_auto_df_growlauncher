# BOREN STORE - AUTO DIRT FARM PRO

Skrip otomatisasi Auto Dirt Farm Pro untuk Growlauncher dengan dukungan Break 3 Tile, Cave Background, Platform, Auto Restock, dan Console ImGui.

## Repository Khusus
Repository ini dikhususkan **HANYA** untuk skrip dan loader **Dirt Farm**.
Tidak ada file dari skrip lain (Plant, Dirt Farm, Soil Builder, Transfer, Harvest) yang tercampur di sini.

## File Utama
- `auto_dirt_farm.lua`: Skrip mandiri lengkap (Full Engine & UI)
- `loader.lua`: Loader langsung untuk `auto_dirt_farm.lua` dengan auto-fetch & auto-update dari GitHub
- `loader_dirt_farm.lua`: Loader Console ImGui khusus fitur Dirt Farm
- `mod_dirt_farm.lua`: Modul ImGui Console
- `imgui_hub/`: Direktori bootloader dan dependensi runtime Console ImGui mandiri

## Cara Menjalankan di Growlauncher
1. **Menggunakan Loader Otomatis:**
   Eksekusi kode berikut di executor Growlauncher:
   ```lua
   fetch("https://raw.githubusercontent.com/rendhi69/sc_auto_df_growlauncher/main/loader.lua?v=" .. os.time())()
   ```
   atau jalankan file `loader.lua` yang tersimpan di perangkat Anda.

2. **Menggunakan Console ImGui:**
   Jalankan `loader_dirt_farm.lua`.

---
Dikembangkan oleh **Boren Store** / **rendhi69**.
