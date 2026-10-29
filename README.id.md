<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**Pencadangan tanpa batas dalam kualitas asli, dengan Video Boost**

Google Foto → foto profil Anda → **Pixel Photos Evolved**.

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [Español](README.es.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · **Bahasa Indonesia** · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#kompatibilitas)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#build)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **Diuji dengan Google Foto 7.98.0.1007591100 (`52591217`) di Android 17 (API 37), Pixel 8 Pro,
> Vector 2.2 / libxposed API 102.** PPE menemukan setiap class Foto yang di-hook dengan DexKit,
> sehingga sebagian besar update Foto tidak memerlukan build modul baru. Jika sebuah class tidak
> ditemukan, Foto tetap berperilaku seperti biasa dan **Kompatibilitas & diagnostik** menampilkan apa
> yang tidak tersedia. Lihat [laporan DexKit](report/dexkit-1.4.1.md) (dalam bahasa Inggris).

> [!IMPORTANT]
> Google menentukan kelayakan pencadangan dan cara penghitungan penyimpanan di servernya. Modul ini
> mengubah apa yang dilaporkan Google Foto di ponsel ini. Modul ini tidak dapat menjamin penyimpanan
> tanpa batas, dan penggunaannya mungkin bertentangan dengan persyaratan layanan Google. Periksa
> penyimpanan akun Anda setelah mengaktifkan opsi pencadangan apa pun.

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>Kartu sendiri di menu profil</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>Bergaya seperti setelan Google Foto</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Kompatibilitas &amp; diagnostik</sub></td>
</tr>
</table>

## Mengapa dibuat seperti ini

Kebanyakan modul memberi Anda aplikasi setelan kedua. Modul ini tidak: tidak ada ikon launcher dan
tidak ada activity setelan. Halamannya terbuka dari kartunya sendiri di menu profil Google Foto, di
atas **Data Anda di Google Foto** dan terpisah darinya. Modul ini memakai font, warna, tombol, dan
animasi milik Foto, serta menyimpan setelannya di direktori data Foto sendiri.

|  | |
|---|---|
| 🧭 **Di tempat yang sudah Anda kenal** | Foto profil → Pixel Photos Evolved. Kembali akan membuka menu lagi. |
| 🎨 **Tampil seperti Foto** | Skala huruf Foto, warna kartu, tombol Material, dan easing yang ditekankan untuk transisi halaman. Tema terang dan gelap mengikuti Foto. |
| 🌐 **Berbicara dalam bahasa Anda** | English, 简体中文, 繁體中文, Español, Português, Русский, 日本語, 한국어, Bahasa Indonesia, dan Bahasa Melayu. Mengikuti bahasa ponsel atau bahasa aplikasi yang disetel untuk Google Foto. |
| 🛡 **Mengenali Foto yang dijalankan** | Setiap hook diperiksa terhadap build Foto yang berjalan sebelum dipasang. Hook yang hilang atau berubah hanya menonaktifkan fiturnya sendiri. |
| 🧠 **Kebijakan dalam Brainfuck** | Keputusan pencadangan dan Video Boost dijalankan oleh program Brainfuck yang dikompilasi (ARM64), dipanggil melalui ABI kecil yang tetap. |
| 🎞 **Byte video asli** | Klaim ulang menyimpan salinan aman, hanya menghapus video cloud yang dipilih beserta salinannya di Sampah, lalu mengupload byte yang sama lagi tanpa encode ulang. |
| 🔒 **Terbatas** | Hanya `com.google.android.apps.photos`. Tanpa hook di seluruh sistem; modul tidak memerlukan root. |

---

## Fitur

<details open>
<summary><b>☁️ Pencadangan</b></summary>
<br>

| Setelan | Fungsinya |
|---|---|
| **Kualitas Asli Tanpa Batas** | Menerapkan identitas Pixel XL (2016) di dalam Google Foto, sehingga Foto menawarkan ketentuan pencadangan Pixel XL. Fitur pengeditan ponsel Anda sendiri tetap tersedia. |
| **Penghemat Penyimpanan Tanpa Batas** | Menerapkan identitas Pixel lama yang dipilih sebagai gantinya. Setelan ini dan Kualitas Asli Tanpa Batas saling menonaktifkan. Foto hanya menerapkannya jika kualitas pencadangan disetel ke Penghemat penyimpanan. |

Perubahan identitas berlaku saat Google Foto dimulai. Setelah perubahan, PPE menawarkan **Mulai ulang sekarang**, yang menutup dan membuka lagi Foto dengan satu ketukan. Opsi ini tidak ditawarkan saat klaim ulang sedang berjalan.

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| Setelan | Fungsinya |
|---|---|
| **Video Boost** | Mendeteksi rekaman Video Boost dan menguploadnya dengan identitas asli ponsel, agar Google dapat memprosesnya sementara pencadangan lain tetap memakai identitas pencadangan. Hanya di ponsel yang merekam Video Boost: Pixel 8 Pro dan seri Pixel 9–11 Pro, termasuk model XL dan Fold. |
| **Klaim Ulang Penyimpanan Video Boost** | Pindai video yang ditingkatkan dan memakai penyimpanan, pilih, lalu klaim ulang: PPE mendownload setiap video, menghapus salinan cloud-nya (juga dari Sampah), lalu menguploadnya lagi dengan setelan Pencadangan Anda. Video yang diupload ulang kehilangan tag dan tautan Video Boost. |

Video yang diproses dengan Video Boost dihitung dalam penyimpanan Akun Google Anda, meski opsi
pencadangan tanpa batas aktif. Lihat [Video Boost](docs/VIDEO_BOOST.md) (dalam bahasa Inggris) tentang
cara upload dikenali dan diarahkan.

Build pengembangan lokal adalah **1.1.0 / 36**. [Halaman klaim ulang](docs/VIDEO_BOOST_RECLAIM.md)
(dalam bahasa Inggris) meminta konfirmasi, lalu memproses satu video sekaligus: download → periksa →
hapus salinan cloud → hapus dari Sampah → upload lagi → periksa penyimpanan. Kartu progres menampilkan
video dan langkah saat ini, dan daftar riwayat menyimpan hasil sebelumnya. Salinan aman tetap di ponsel
sampai setiap video selesai, dan proses yang terputus dapat dilanjutkan. Pindaian memakai cache Foto,
sehingga tidak dapat memastikan seluruh galeri tercakup. Lihat
[laporan klaim ulang](report/reclaim-7.98-1.3.2.md) (dalam bahasa Inggris).

</details>

---

## Kompatibilitas

| Android | Google Foto | Perangkat | Status |
|---|---|---|---|
| 17 (API 37) | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0: semua class ditemukan oleh DexKit, uji pencadangan lulus, klaim ulang diverifikasi dengan video uji (1.3.2) |
| 17 QPR1 (CP3A.261005.005) | 7.97.0.1000520730 | Pixel 8 Pro | Aturan DexKit divalidasi terhadap DEX build ini; terakhir diuji di perangkat dengan 1.2.2-dev |

- **Syarat aktif.** Saat dimulai, modul memeriksa Android API 37, ARM64, dan apakah DexKit menemukan
  setiap class yang diperlukan. Jika tidak, modul tidak memasang apa pun yang mengubah perilaku.
- **Hook per fitur.** Hook pencadangan dan Video Boost dicari dan diperiksa secara terpisah. Jika salah
  satunya tidak ada, barisnya di diagnostik menampilkan *Tidak kompatibel dengan Google Foto …* dan yang
  lain tetap berfungsi.
- **Kompatibilitas &amp; diagnostik** menampilkan versi modul, Android, perangkat, versi Google Foto,
  API libxposed dan framework, serta status setiap fitur: kompatibel, dinonaktifkan, atau tidak
  tersedia. **Log diagnostik** menambahkan detail ke `adb logcat -s PixelPhotosEvolved`. Log tetap
  dalam bahasa Inggris.

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Modul dan sistem</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>Kompatibilitas fitur</sub></td>
</tr>
</table>

---

## Persyaratan

- Android 17 (API 37), ARM64. APK dapat dipasang mulai Android 13, tetapi hook hanya aktif di Android 17
- Framework Xposed dengan **libxposed API 102** (diuji dengan Vector 2.2)
- Google Foto 7.98.0.1007591100 (diuji); build lain berfungsi jika aturan DexKit menemukan semua class yang diperlukan (hasilnya ditampilkan di Kompatibilitas &amp; diagnostik)

## Pemasangan

1. Pasang APK dari [rilis terbaru](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest)
   atau [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved).
2. Aktifkan **Pixel Photos Evolved** di pengelola Xposed Anda, dengan cakupan **Google Foto**
   (`com.google.android.apps.photos`).
3. Hentikan paksa Google Foto lalu buka lagi.
4. Foto profil → **Pixel Photos Evolved**.

Untuk mematikannya, nonaktifkan modul di pengelola Xposed dan mulai ulang Google Foto. Selengkapnya di
[pemasangan dan pemecahan masalah](docs/INSTALLATION_AND_TROUBLESHOOTING.md) (dalam bahasa Inggris).

APK rilis dibuat di sini dan ditandatangani ulang dengan kunci rilis oleh
[alur kerja rilis](.github/workflows/release.yml), yang juga mencerminkan setiap rilis ke Xposed Modules
Repository. [module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk) adalah build
yang sama yang ditandatangani dengan kunci uji publik XAX, untuk mereproduksinya.

## Cara kerja

| Bagian | Lokasi | Fungsinya |
|---|---|---|
| Modul | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | Store XAX kanonis: siklus hidup, hook, UI setelan, dan diagnostik, dikompilasi ke DEX oleh target android-libxposed XAX |
| Kebijakan | [policy/](policy/) | Kebijakan Brainfuck yang dikompilasi BBC menjadi executable stdio ARM64, dikemas sebagai `lib/arm64-v8a/libppepolicy.so` ([ABI](policy/ABI.md)). Bukan library JNI |
| Dependensi DexKit | [module/deps/](module/deps/) dan `module/libdexkit.so` | DEX dependensi yang telah dikompilasi dan JNI ARM64 yang menemukan class Foto yang diobfuskasi saat runtime; [pemberitahuan](docs/THIRD_PARTY.md) |
| Resource | [module/res/](module/res/) | Nama, deskripsi, ikon adaptif, dan teks UI dalam sepuluh bahasa (`values*/`) |

## Terjemahan

Teks UI ada di resource string Android standar: bahasa Inggris di `module/res/values/ui_strings.xml` dan
satu `module/res/values-*/strings.xml` per bahasa. Untuk memperbaiki terjemahan, edit string dengan
`name` yang sama di file bahasa tersebut. Untuk menambah bahasa, buat folder `values-<locale>` berisi
semua kunci `ppe_*`. Kunci yang tidak ada ditampilkan dalam bahasa Inggris.

## Build

Di repositori ini, hanya Brainfuck dan XAX kanonis yang merupakan kode sumber. Build memakai SDK XAX yang
dikunci di [toolchain.lock.json](toolchain.lock.json); alat build konvensional berada di luar
repositori. [Mereproduksi build](docs/REPRODUCE.md) (dalam bahasa Inggris) menjelaskan langkah-langkah
tepatnya: verifikasi store, build executable kebijakan dan APK modul dengan XAX, tambahkan resource
dengan aapt2, lalu tandatangani. [SHA256SUMS](SHA256SUMS) mencantumkan setiap file yang disimpan.

## Bukti

[Status](report/STATUS.md) memisahkan apa yang diperiksa di perangkat, apa yang diperiksa secara offline,
dan apa yang belum diuji. [Indeks bukti](docs/EVIDENCE.md) menautkan setiap laporan (dalam bahasa Inggris).

## Kredit

- [XAX](https://github.com/MrxSiN/XAX) — bahasa, store semantik, dan target Android
- [BBC](https://github.com/MrxSiN/BBC) — compiler Brainfuck
- [DexKit](https://github.com/LuckyPray/DexKit) — pencarian DEX saat runtime ([pemberitahuan dependensi](docs/THIRD_PARTY.md))
- [libxposed](https://github.com/libxposed/api) dan Vector

Lihat [atribusi](docs/ATTRIBUTION.md). Pixel Photos Evolved tidak berafiliasi dengan atau didukung oleh
Google. Google Foto dan Pixel adalah merek dagang Google LLC.
