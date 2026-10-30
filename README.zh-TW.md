<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**無限原始畫質備份，支援 Video Boost**

Google 相簿 → 你的個人資料相片 → **Pixel Photos Evolved**。

[English](README.md) · [简体中文](README.zh-CN.md) · **繁體中文** · [Español](README.es.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Bahasa Indonesia](README.id.md) · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#相容性)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#建置)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **已在 Android 17（API 37）、Pixel 8 Pro、Vector 2.2 / libxposed API 102 上搭配 Google 相簿
> 7.98.0.1007591100（`52591217`）測試。** PPE 透過 DexKit 尋找它要掛鉤的每個相簿類別，因此大多數相簿
> 更新不需要重新建置模組。如果找不到某個類別，相簿會維持原本的行為，**相容性與診斷**頁面會顯示哪些功能無法使用。
> 詳情請參閱 [DexKit 報告](report/dexkit-1.4.1.md)（英文）。

> [!IMPORTANT]
> 備份資格和儲存空間的計算方式由 Google 在伺服器上決定。本模組只會改變這支手機上的 Google 相簿所回報的內容，
> 無法保證無限儲存空間，使用它也可能違反 Google 服務條款。開啟任何備份選項後，請檢查帳戶的儲存空間。

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>個人資料選單中的專屬卡片</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>與 Google 相簿設定風格一致</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>相容性與診斷</sub></td>
</tr>
</table>

## 設計理念

大多數模組會另外給你一個設定應用程式。本模組沒有：沒有啟動器圖示，也沒有設定 Activity。它的頁面從 Google 相簿
個人資料選單中的專屬卡片開啟，位於 **你在 Google 相簿中的資料** 上方，並與其分開。它使用相簿本身的字型、色彩、
開關和動畫，並將設定儲存在相簿本身的資料目錄中。

|  | |
|---|---|
| 🧭 **就在你熟悉的位置** | 個人資料相片 → Pixel Photos Evolved。按返回即回到選單。 |
| 🎨 **外觀與相簿一致** | 相簿的字級系統、卡片色彩、Material 開關，以及頁面轉場的強調緩動。淺色和深色主題跟隨相簿。 |
| 🌐 **支援你的語言** | English、简体中文、繁體中文、Español、Português、Русский、日本語、한국어、Bahasa Indonesia 和 Bahasa Melayu。跟隨手機語言或為 Google 相簿個別設定的應用程式語言。 |
| 🛡 **了解所執行的相簿版本** | 每個掛鉤在安裝前都會針對正在執行的相簿版本進行檢查。某個掛鉤遺失或變更時，只會停用其對應的功能。 |
| 🧠 **以 Brainfuck 實作策略** | 備份和 Video Boost 的判斷由編譯後的 Brainfuck 程式（ARM64）執行，透過固定的小型 ABI 呼叫。 |
| 🎞 **原始影片位元組** | 回收時會保留一份安全副本，只刪除所選的雲端影片及其垃圾桶副本，然後不經重新編碼上傳相同的位元組。 |
| 🔒 **範圍受限** | 僅作用於 `com.google.android.apps.photos`。沒有系統層級的掛鉤，模組本身不需要 root。 |

---

## 功能

<details open>
<summary><b>☁️ 備份</b></summary>
<br>

| 設定 | 作用 |
|---|---|
| **無限原始畫質** | 在 Google 相簿內使用 Pixel XL（2016）身分，讓相簿提供 Pixel XL 的備份條款。手機本身的編輯功能仍可使用。 |
| **無限節省空間** | 改用所選舊款 Pixel 的身分。它與「無限原始畫質」互斥。只有在備份畫質設為「節省空間」時，相簿才會採用。 |

身分變更會在 Google 相簿啟動時生效。變更後，PPE 會提供 **立即重新啟動**，一鍵關閉並重新開啟相簿。回收進行期間不會提供這個選項。

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| 設定 | 作用 |
|---|---|
| **Video Boost** | 偵測以 Video Boost 錄製的影片，並以手機的真實身分上傳，讓 Google 能處理這些影片，而其他備份則維持備份身分。僅適用於可錄製 Video Boost 的手機：Pixel 8 Pro 以及 Pixel 9–11 Pro 系列（包括 XL 和 Fold 機型）。 |
| **Video Boost 儲存空間回收** | 掃描佔用儲存空間的強化影片，選取後即可回收：PPE 會逐一下載影片、刪除雲端副本（包括垃圾桶中的），然後依你的備份設定重新上傳。重新上傳的影片會遺失 Video Boost 標記和連結。 |

即使開啟了無限備份選項，經 Video Boost 處理的影片仍會計入你的 Google 帳戶儲存空間。上傳如何被辨識和轉送，
請參閱 [Video Boost](docs/VIDEO_BOOST.md)（英文）。

本機開發版本為 **1.1.1 / 37**。[回收頁面](docs/VIDEO_BOOST_RECLAIM.md)（英文）會先要求確認，然後逐一處理影片：
下載 → 檢查 → 刪除雲端副本 → 從垃圾桶清除 → 重新上傳 → 檢查儲存空間。進度卡片會顯示目前的影片和步驟，記錄清單會保留過去的結果。
每部影片完成前，手機上都會保留一份安全副本，中斷的工作可以繼續。掃描使用相簿的快取，因此無法保證涵蓋整個媒體庫。
詳情請參閱 [回收報告](report/reclaim-7.98-1.3.2.md)（英文）。

</details>

---

## 相容性

| Android | Google 相簿 | 裝置 | 狀態 |
|---|---|---|---|
| 17（API 37） | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0：所有類別皆由 DexKit 找到，備份探測通過，回收已在測試影片上驗證（1.3.2） |
| 17 QPR1（CP3A.261005.005） | 7.97.0.1000520730 | Pixel 8 Pro | DexKit 規則已針對此版本的 DEX 驗證；最後一次實機測試為 1.2.2-dev |

- **啟用條件。** 啟動時模組會檢查 Android API 37、ARM64，以及 DexKit 是否解析出所需的每個類別。否則它不會安裝任何改變行為的掛鉤。
- **依功能掛鉤。** 備份和 Video Boost 的掛鉤會分別尋找和檢查。如果其中一個遺失，診斷中對應的一列會顯示 *不相容於 Google 相簿 …*，另一個照常運作。
- **相容性與診斷** 會顯示模組版本、Android、裝置、Google 相簿版本、libxposed API 和框架，並將每個功能標示為相容、已停用或無法使用。
  **診斷記錄** 會在 `adb logcat -s PixelPhotosEvolved` 中加入詳細資訊。記錄維持英文。

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>模組和系統</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>功能相容性</sub></td>
</tr>
</table>

---

## 需求

- Android 17（API 37），ARM64。APK 可安裝於 Android 13 以上，但掛鉤只會在 Android 17 上啟用
- 支援 **libxposed API 102** 的 Xposed 框架（已使用 Vector 2.2 測試）
- Google 相簿 7.98.0.1007591100（已測試）；只要 DexKit 規則能解析出所有必要的類別，其他版本也可使用（相容性與診斷頁面會顯示結果）

## 安裝

1. 從 [最新版本](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest) 或
   [Xposed 模組儲存庫](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved) 安裝 APK。
2. 在 Xposed 管理器中啟用 **Pixel Photos Evolved**，範圍設為 **Google 相簿**（`com.google.android.apps.photos`）。
3. 強制停止 Google 相簿並重新開啟。
4. 個人資料相片 → **Pixel Photos Evolved**。

如要關閉，請在 Xposed 管理器中停用模組並重新啟動 Google 相簿。更多內容請參閱
[安裝與疑難排解](docs/INSTALLATION_AND_TROUBLESHOOTING.md)（英文）。

正式版 APK 在此建置，並由 [發布工作流程](.github/workflows/release.yml) 以發布金鑰重新簽署，同時同步到 Xposed 模組儲存庫。
[module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk) 是以 XAX 公開測試金鑰簽署的相同建置，用於重現。

## 運作方式

| 組成部分 | 位置 | 作用 |
|---|---|---|
| 模組 | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | 標準 XAX 儲存：生命週期、掛鉤、設定介面和診斷，由 XAX android-libxposed 目標編譯為 DEX |
| 策略 | [policy/](policy/) | 由 BBC 編譯為 ARM64 stdio 可執行檔的 Brainfuck 策略，封裝為 `lib/arm64-v8a/libppepolicy.so`（[ABI](policy/ABI.md)）。它不是 JNI 程式庫 |
| DexKit 相依元件 | [module/deps/](module/deps/) 和 `module/libdexkit.so` | 預先編譯的相依 DEX 和 ARM64 JNI，在執行時尋找經混淆的相簿類別；[聲明](docs/THIRD_PARTY.md) |
| 資源 | [module/res/](module/res/) | 名稱、說明、自適應圖示，以及十種語言的介面文字（`values*/`） |

## 翻譯

介面文字使用標準的 Android 字串資源：英文位於 `module/res/values/ui_strings.xml`，每種語言各有一個
`module/res/values-*/strings.xml`。如要修正翻譯，請在該語言的檔案中編輯相同 `name` 的字串。如要新增語言，
請建立 `values-<locale>` 資料夾並包含所有 `ppe_*` 鍵。缺少的鍵會改用英文。

## 建置

本儲存庫中只有 Brainfuck 和標準 XAX 屬於原始碼。建置使用 [toolchain.lock.json](toolchain.lock.json) 中固定版本的
XAX SDK；一般建置工具放在儲存庫之外。[重現建置](docs/REPRODUCE.md)（英文）列出確切步驟：驗證儲存，以 XAX
建置策略可執行檔和模組 APK，以 aapt2 加入資源，然後簽署。[SHA256SUMS](SHA256SUMS) 列出所有保留的檔案。

## 證據

[狀態](report/STATUS.md) 區分了在裝置上檢查過、離線檢查過以及尚未測試的內容。[證據索引](docs/EVIDENCE.md) 連結所有報告（英文）。

## 致謝

- [XAX](https://github.com/MrxSiN/XAX) — 語言、語意儲存和 Android 目標
- [BBC](https://github.com/MrxSiN/BBC) — Brainfuck 編譯器
- [DexKit](https://github.com/LuckyPray/DexKit) — 執行時 DEX 搜尋（[相依元件聲明](docs/THIRD_PARTY.md)）
- [libxposed](https://github.com/libxposed/api) 和 Vector

請參閱 [署名](docs/ATTRIBUTION.md)。Pixel Photos Evolved 與 Google 沒有關聯，也未獲得 Google 認可。
Google Photos 和 Pixel 是 Google LLC 的商標。
