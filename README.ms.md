<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**Sandaran tanpa had dalam kualiti asal, dengan Video Boost**

Google Foto → gambar profil anda → **Pixel Photos Evolved**.

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [Español](README.es.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Bahasa Indonesia](README.id.md) · **Bahasa Melayu**

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#keserasian)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#bina)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **Diuji dengan Google Foto 7.98.0.1007591100 (`52591217`) pada Android 17 (API 37), Pixel 8 Pro,
> Vector 2.2 / libxposed API 102.** PPE menemui setiap kelas Foto yang dicangkuknya dengan DexKit,
> jadi kebanyakan kemas kini Foto tidak memerlukan binaan modul baharu. Jika sesuatu kelas tidak
> ditemui, Foto mengekalkan tingkah lakunya sendiri dan **Keserasian & diagnostik** menunjukkan apa
> yang tidak tersedia. Lihat [laporan DexKit](report/dexkit-1.4.1.md) (dalam bahasa Inggeris).

> [!IMPORTANT]
> Google menentukan kelayakan sandaran dan cara storan dikira, pada pelayannya. Modul ini mengubah apa
> yang dilaporkan oleh Google Foto pada telefon ini. Ia tidak dapat menjanjikan storan tanpa had, dan
> penggunaannya mungkin bercanggah dengan syarat perkhidmatan Google. Semak storan akaun anda selepas
> mendayakan sebarang pilihan sandaran.

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>Kad sendiri dalam menu profil</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>Direka seperti tetapan Google Foto</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Keserasian &amp; diagnostik</sub></td>
</tr>
</table>

## Mengapa ia berfungsi begini

Kebanyakan modul memberi anda apl tetapan kedua. Modul ini tidak: tiada ikon pelancar dan tiada
aktiviti tetapan. Halamannya dibuka daripada kadnya sendiri dalam menu profil Google Foto, di atas
**Data anda dalam Google Foto** dan berasingan daripadanya. Ia menggunakan fon, warna, suis dan
animasi Foto sendiri, serta menyimpan tetapannya dalam direktori data Foto sendiri.

|  | |
|---|---|
| 🧭 **Di tempat anda sudah berada** | Gambar profil → Pixel Photos Evolved. Kembali membawa anda semula ke menu. |
| 🎨 **Kelihatan seperti Foto** | Skala taip Foto, warna kad, suis Material dan pelonggaran yang ditekankan untuk peralihan halaman. Tema cerah dan gelap mengikut Foto. |
| 🌐 **Bertutur dalam bahasa anda** | English, 简体中文, 繁體中文, Español, Português, Русский, 日本語, 한국어, Bahasa Indonesia dan Bahasa Melayu. Mengikut bahasa telefon atau bahasa apl yang ditetapkan untuk Google Foto. |
| 🛡 **Mengenali Foto yang dijalankan** | Setiap cangkuk disemak terhadap binaan Foto yang sedang berjalan sebelum dipasang. Cangkuk yang hilang atau berubah hanya melumpuhkan cirinya sendiri. |
| 🧠 **Dasar dalam Brainfuck** | Keputusan sandaran dan Video Boost dijalankan oleh program Brainfuck yang dikompil (ARM64), dipanggil melalui ABI kecil yang tetap. |
| 🎞 **Bait video asal** | Tuntutan semula menyimpan salinan selamat, hanya memadamkan video awan yang dipilih dan salinannya dalam Sampah, kemudian memuat naik bait yang sama sekali lagi tanpa pengekodan semula. |
| 🔒 **Berskop** | Hanya `com.google.android.apps.photos`. Tiada cangkuk seluruh sistem; modul tidak memerlukan root. |

---

## Ciri

<details open>
<summary><b>☁️ Sandaran</b></summary>
<br>

| Tetapan | Fungsinya |
|---|---|
| **Kualiti Asal Tanpa Had** | Menggunakan identiti Pixel XL (2016) dalam Google Foto, supaya Foto menawarkan terma sandaran Pixel XL. Ciri pengeditan telefon anda sendiri kekal tersedia. |
| **Penjimat Storan Tanpa Had** | Menggunakan identiti Pixel lama yang dipilih sebagai gantinya. Tetapan ini dan Kualiti Asal Tanpa Had saling mematikan. Foto hanya menggunakannya apabila kualiti sandaran ditetapkan kepada Penjimat storan. |

Perubahan identiti berkuat kuasa apabila Google Foto dimulakan. Selepas perubahan, PPE menawarkan **Mulakan semula sekarang**, yang menutup dan membuka semula Foto dengan satu ketikan. Pilihan ini tidak ditawarkan semasa tuntutan semula sedang berjalan.

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| Tetapan | Fungsinya |
|---|---|
| **Video Boost** | Mengesan rakaman Video Boost dan memuat naiknya dengan identiti sebenar telefon, supaya Google dapat memprosesnya manakala sandaran lain mengekalkan identiti sandaran. Hanya pada telefon yang merakam Video Boost: Pixel 8 Pro dan siri Pixel 9–11 Pro, termasuk model XL dan Fold. |
| **Tuntut Semula Storan Video Boost** | Imbas video yang dipertingkat dan menggunakan storan, pilih, kemudian tuntut semula: PPE memuat turun setiap video, memadamkan salinan awannya (juga daripada Sampah), kemudian memuat naiknya semula dengan tetapan Sandaran anda. Video yang dimuat naik semula kehilangan teg dan pautan Video Boost. |

Video yang diproses dengan Video Boost dikira dalam storan Akaun Google anda, walaupun pilihan sandaran
tanpa had dihidupkan. Lihat [Video Boost](docs/VIDEO_BOOST.md) (dalam bahasa Inggeris) tentang cara
muat naik dikenal pasti dan dihalakan.

Binaan pembangunan setempat ialah **1.1.0 / 36**. [Halaman tuntutan semula](docs/VIDEO_BOOST_RECLAIM.md)
(dalam bahasa Inggeris) meminta pengesahan, kemudian memproses satu video pada satu masa: muat turun →
semak → padam salinan awan → kosongkan daripada Sampah → muat naik semula → semak storan. Kad kemajuan
menunjukkan video dan langkah semasa, dan senarai sejarah menyimpan keputusan terdahulu. Salinan selamat
kekal pada telefon sehingga setiap video selesai, dan proses yang terganggu boleh disambung semula.
Imbasan menggunakan cache Foto, jadi ia tidak dapat memastikan seluruh pustaka diliputi. Lihat
[laporan tuntutan semula](report/reclaim-7.98-1.3.2.md) (dalam bahasa Inggeris).

</details>

---

## Keserasian

| Android | Google Foto | Peranti | Status |
|---|---|---|---|
| 17 (API 37) | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0: semua kelas ditemui oleh DexKit, ujian sandaran lulus, tuntutan semula disahkan dengan video ujian (1.3.2) |
| 17 QPR1 (CP3A.261005.005) | 7.97.0.1000520730 | Pixel 8 Pro | Peraturan DexKit disahkan terhadap DEX binaan ini; kali terakhir diuji pada peranti dengan 1.2.2-dev |

- **Syarat aktif.** Semasa dimulakan, modul menyemak Android API 37, ARM64, dan sama ada DexKit menemui
  setiap kelas yang diperlukan. Jika tidak, ia tidak memasang apa-apa yang mengubah tingkah laku.
- **Cangkuk mengikut ciri.** Cangkuk sandaran dan Video Boost dicari dan disemak secara berasingan. Jika
  salah satu tiada, barisnya dalam diagnostik menunjukkan *Tidak serasi dengan Google Foto …* dan yang
  satu lagi terus berfungsi.
- **Keserasian &amp; diagnostik** menunjukkan versi modul, Android, peranti, versi Google Foto, API
  libxposed dan rangka kerja, serta status setiap ciri: serasi, dilumpuhkan atau tidak tersedia.
  **Log diagnostik** menambahkan butiran pada `adb logcat -s PixelPhotosEvolved`. Log kekal dalam
  bahasa Inggeris.

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Modul dan sistem</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>Keserasian ciri</sub></td>
</tr>
</table>

---

## Keperluan

- Android 17 (API 37), ARM64. APK boleh dipasang mulai Android 13, tetapi cangkuk hanya aktif pada Android 17
- Rangka kerja Xposed dengan **libxposed API 102** (diuji dengan Vector 2.2)
- Google Foto 7.98.0.1007591100 (diuji); binaan lain berfungsi apabila peraturan DexKit menemui semua kelas yang diperlukan (keputusan ditunjukkan dalam Keserasian &amp; diagnostik)

## Pemasangan

1. Pasang APK daripada [keluaran terkini](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest)
   atau [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved).
2. Dayakan **Pixel Photos Evolved** dalam pengurus Xposed anda, dengan skop **Google Foto**
   (`com.google.android.apps.photos`).
3. Henti paksa Google Foto dan bukanya semula.
4. Gambar profil → **Pixel Photos Evolved**.

Untuk mematikannya, lumpuhkan modul dalam pengurus Xposed dan mulakan semula Google Foto. Maklumat lanjut
dalam [pemasangan dan penyelesaian masalah](docs/INSTALLATION_AND_TROUBLESHOOTING.md) (dalam bahasa Inggeris).

APK keluaran dibina di sini dan ditandatangani semula dengan kunci keluaran oleh
[aliran kerja keluaran](.github/workflows/release.yml), yang turut mencerminkan setiap keluaran ke Xposed
Modules Repository. [module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk) ialah
binaan yang sama yang ditandatangani dengan kunci ujian awam XAX, untuk menghasilkannya semula.

## Cara ia berfungsi

| Bahagian | Lokasi | Fungsinya |
|---|---|---|
| Modul | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | Stor XAX kanonik: kitaran hayat, cangkuk, UI tetapan dan diagnostik, dikompil ke DEX oleh sasaran android-libxposed XAX |
| Dasar | [policy/](policy/) | Dasar Brainfuck yang dikompil oleh BBC menjadi boleh laku stdio ARM64, dibungkus sebagai `lib/arm64-v8a/libppepolicy.so` ([ABI](policy/ABI.md)). Ia bukan pustaka JNI |
| Kebergantungan DexKit | [module/deps/](module/deps/) dan `module/libdexkit.so` | DEX kebergantungan yang telah dikompil dan JNI ARM64 yang menemui kelas Foto yang dikaburkan semasa masa jalan; [notis](docs/THIRD_PARTY.md) |
| Sumber | [module/res/](module/res/) | Nama, perihalan, ikon adaptif dan teks UI dalam sepuluh bahasa (`values*/`) |

## Terjemahan

Teks UI berada dalam sumber rentetan Android standard: bahasa Inggeris dalam
`module/res/values/ui_strings.xml` dan satu `module/res/values-*/strings.xml` bagi setiap bahasa. Untuk
membetulkan terjemahan, edit rentetan dengan `name` yang sama dalam fail bahasa itu. Untuk menambah
bahasa, cipta folder `values-<locale>` dengan semua kunci `ppe_*`. Kunci yang tiada dipaparkan dalam
bahasa Inggeris.

## Bina

Dalam repositori ini, hanya Brainfuck dan XAX kanonik ialah kod sumber. Binaan menggunakan SDK XAX yang
dikunci dalam [toolchain.lock.json](toolchain.lock.json); alat binaan konvensional berada di luar
repositori. [Menghasilkan semula binaan](docs/REPRODUCE.md) (dalam bahasa Inggeris) menerangkan langkah
tepat: sahkan stor, bina boleh laku dasar dan APK modul dengan XAX, tambah sumber dengan aapt2, dan
tandatangani. [SHA256SUMS](SHA256SUMS) menyenaraikan setiap fail yang disimpan.

## Bukti

[Status](report/STATUS.md) memisahkan apa yang disemak pada peranti, apa yang disemak di luar talian dan
apa yang belum diuji. [Indeks bukti](docs/EVIDENCE.md) memaut setiap laporan (dalam bahasa Inggeris).

## Penghargaan

- [XAX](https://github.com/MrxSiN/XAX) — bahasa, stor semantik dan sasaran Android
- [BBC](https://github.com/MrxSiN/BBC) — pengkompil Brainfuck
- [DexKit](https://github.com/LuckyPray/DexKit) — penemuan DEX semasa masa jalan ([notis kebergantungan](docs/THIRD_PARTY.md))
- [libxposed](https://github.com/libxposed/api) dan Vector

Lihat [atribusi](docs/ATTRIBUTION.md). Pixel Photos Evolved tidak bergabung dengan atau disokong oleh
Google. Google Foto dan Pixel ialah tanda dagangan Google LLC.
