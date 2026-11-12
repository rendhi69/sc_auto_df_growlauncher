# Auto Dirt Farm - Growlauncher

Skrip otomatisasi pembuatan Dirt Farm (DF) untuk **Growlauncher** dengan antarmuka native UI modern (Boren Store).

## Fitur Utama
- **Penataan Lock & Security Moat**: Pemasangan White Door, Small Lock (Private), Jammer, World Lock (Public), Left Blocker (Air Vent), dan Door ID di koordinat `(0,0)` dengan jeda aman & mode Fly.
- **Pembersihan Pinggir (Clear Sides)**:
  - Mode **Platform Aktif**: membersihkan 2 kolom pinggir pada sisi yang dipasang platform (`x = 1, 0` dan/atau `x = 98, 99`).
  - Mode **Platform Nonaktif**: hanya membersihkan 1 kolom pinggir (`x = 0` dan `x = 99`), jalur horizontal DF penuh `x = 1..98`.
- **Auto Tanam & Panen Dirt Seed**: Tanam secukupnya sesuai setting `Max Tanam`, tunggu pohon matang, panen, dan langsung gunakan untuk menambal DF.
- **Sistem Auto-Trash Dinamis**: Dialog manajer untuk menambah, mengedit, menghapus, atau mereset daftar item yang di-trash dengan ambang batas (threshold) kuantitas.
- **Penyimpanan Seed ke Storage**: Otomatis menyimpan bibit (Cave, Lava, Rock Seed) langsung ke storage seed; Dirt Seed dicadangkan di world DF dan disimpan penuh setelah world selesai.
- **Deteksi Halangan Simetri DF**: Otomatis mendeteksi dan membersihkan blok troll atau blok asing yang merusak simetri garis DF.

## Cara Menggunakan via Loader (Rekomendasi)
Cukup jalankan file `loader.lua` di Growlauncher:

```lua
local RAW_URL = "https://raw.githubusercontent.com/rendhi69/sc_auto_df_growlauncher/main/auto_dirt_farm.lua"
local content, err = fetch(RAW_URL .. "?v=" .. tostring(os.time()))
if content and content ~= "" then
    load(content)()
end
```
Dengan loader ini, Anda tidak perlu lagi mengganti file secara manual di Growlauncher setiap ada pembaruan kode. Cukup perbarui file di GitHub!
