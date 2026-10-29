<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**无限原图画质备份，兼容 Video Boost**

Google 相册 → 您的个人资料照片 → **Pixel Photos Evolved**。

[English](README.md) · **简体中文** · [繁體中文](README.zh-TW.md) · [Español](README.es.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Bahasa Indonesia](README.id.md) · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#兼容性)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#构建)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **已在 Android 17（API 37）、Pixel 8 Pro、Vector 2.2 / libxposed API 102 上使用 Google 相册
> 7.98.0.1007591100（`52591217`）测试。** PPE 通过 DexKit 查找它要挂钩的每个相册类，因此大多数相册
> 更新无需重新构建模块。如果找不到某个类，相册会保持自身行为，**兼容性与诊断**页面会显示哪些功能不可用。
> 详见 [DexKit 报告](report/dexkit-1.4.1.md)（英文）。

> [!IMPORTANT]
> 备份资格和存储空间的计算方式由 Google 在其服务器上决定。本模块只改变此手机上的 Google 相册所报告的内容，
> 无法保证无限存储空间，且使用它可能违反 Google 服务条款。开启任何备份选项后，请检查您账号的存储空间。

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>个人资料菜单中的独立卡片</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>与 Google 相册设置风格一致</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>兼容性与诊断</sub></td>
</tr>
</table>

## 设计思路

大多数模块会另外给您一个设置应用。本模块没有：没有启动器图标，也没有设置 Activity。它的页面从 Google 相册
个人资料菜单中的独立卡片打开，位于 **Google 相册中的您的数据** 上方，并与之分开。它使用相册自己的字体、颜色、
开关和动画，并将设置保存在相册自己的数据目录中。

|  | |
|---|---|
| 🧭 **就在您熟悉的位置** | 个人资料照片 → Pixel Photos Evolved。按返回即回到菜单。 |
| 🎨 **与相册外观一致** | 相册的字号体系、卡片颜色、Material 开关以及页面转场的强调缓动。浅色和深色主题跟随相册。 |
| 🌐 **支持您的语言** | English、简体中文、繁體中文、Español、Português、Русский、日本語、한국어、Bahasa Indonesia 和 Bahasa Melayu。跟随手机语言或为 Google 相册单独设置的应用语言。 |
| 🛡 **了解所运行的相册版本** | 每个挂钩在安装前都会针对正在运行的相册版本进行检查。某个挂钩缺失或变化时，只会停用其对应的功能。 |
| 🧠 **用 Brainfuck 实现策略** | 备份和 Video Boost 的判断由编译后的 Brainfuck 程序（ARM64）执行，通过一个固定的小型 ABI 调用。 |
| 🎞 **原始视频字节** | 回收时会保留一份安全副本，只删除所选的云端视频及其回收站副本，然后不经重新编码上传相同的字节。 |
| 🔒 **范围受限** | 仅作用于 `com.google.android.apps.photos`。没有系统级挂钩，模块本身不需要 root。 |

---

## 功能

<details open>
<summary><b>☁️ 备份</b></summary>
<br>

| 设置 | 作用 |
|---|---|
| **无限原图画质** | 在 Google 相册内使用 Pixel XL（2016）身份，让相册提供 Pixel XL 的备份条款。手机自身的编辑功能仍可使用。 |
| **无限节省存储空间** | 改为使用所选旧款 Pixel 的身份。它与“无限原图画质”互斥。只有当备份画质设为“节省存储空间”时，相册才会采用它。 |

身份更改在 Google 相册启动时生效。更改后，PPE 会提供 **立即重启**，一键关闭并重新打开相册。回收进行期间不会提供此选项。

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| 设置 | 作用 |
|---|---|
| **Video Boost** | 识别 Video Boost 录制的视频，并以手机的真实身份上传，使 Google 能够处理这些视频，而其他备份继续使用备份身份。仅适用于可录制 Video Boost 的手机：Pixel 8 Pro 以及 Pixel 9–11 Pro 系列（包括 XL 和 Fold 机型）。 |
| **Video Boost 存储空间回收** | 扫描占用存储空间的增强视频，选择后进行回收：PPE 会逐个下载视频，删除云端副本（包括回收站中的），然后按您的备份设置重新上传。重新上传的视频会丢失 Video Boost 标记和关联。 |

即使开启了无限备份选项，经 Video Boost 处理的视频仍会计入您的 Google 账号存储空间。上传如何被识别和路由，
请参阅 [Video Boost](docs/VIDEO_BOOST.md)（英文）。

本地开发版本为 **1.1.0 / 36**。[回收页面](docs/VIDEO_BOOST_RECLAIM.md)（英文）会先请求确认，然后逐个处理视频：
下载 → 检查 → 删除云端副本 → 从回收站清除 → 重新上传 → 检查存储空间。进度卡片显示当前视频和步骤，历史记录列表保留以往结果。
每个视频完成前，手机上都会保留一份安全副本，中断的任务可以继续。扫描使用相册的缓存，因此无法保证覆盖整个媒体库。
详见 [回收报告](report/reclaim-7.98-1.3.2.md)（英文）。

</details>

---

## 兼容性

| Android | Google 相册 | 设备 | 状态 |
|---|---|---|---|
| 17（API 37） | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0：所有类均由 DexKit 找到，备份探测通过，回收已在测试视频上验证（1.3.2） |
| 17 QPR1（CP3A.261005.005） | 7.97.0.1000520730 | Pixel 8 Pro | DexKit 规则已针对此版本的 DEX 验证；最后一次真机测试为 1.2.2-dev |

- **启用条件。** 启动时模块会检查 Android API 37、ARM64，以及 DexKit 是否解析出所需的每个类。否则它不会安装任何改变行为的挂钩。
- **按功能挂钩。** 备份和 Video Boost 的挂钩分别查找和检查。如果其中一个缺失，诊断中对应的一行会显示 *不兼容 Google 相册 …*，另一个照常工作。
- **兼容性与诊断** 显示模块版本、Android、设备、Google 相册版本、libxposed API 和框架，并将每个功能标为兼容、已停用或不可用。
  **诊断日志** 会向 `adb logcat -s PixelPhotosEvolved` 添加详细信息。日志保持英文。

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>模块和系统</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>功能兼容性</sub></td>
</tr>
</table>

---

## 要求

- Android 17（API 37），ARM64。APK 可安装于 Android 13 及以上，但挂钩只在 Android 17 上启用
- 支持 **libxposed API 102** 的 Xposed 框架（已用 Vector 2.2 测试）
- Google 相册 7.98.0.1007591100（已测试）；只要 DexKit 规则能解析出所有必需的类，其他版本也可使用（兼容性与诊断页面会显示结果）

## 安装

1. 从 [最新版本](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest) 或
   [Xposed 模块仓库](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved) 安装 APK。
2. 在 Xposed 管理器中启用 **Pixel Photos Evolved**，作用域设为 **Google 相册**（`com.google.android.apps.photos`）。
3. 强行停止 Google 相册并重新打开。
4. 个人资料照片 → **Pixel Photos Evolved**。

如需关闭，请在 Xposed 管理器中停用模块并重启 Google 相册。更多内容见
[安装与故障排除](docs/INSTALLATION_AND_TROUBLESHOOTING.md)（英文）。

发布版 APK 在此构建，并由 [发布工作流](.github/workflows/release.yml) 使用发布密钥重新签名，同时同步到 Xposed 模块仓库。
[module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk) 是使用 XAX 公开测试密钥签名的同一构建，用于复现。

## 工作原理

| 组成部分 | 位置 | 作用 |
|---|---|---|
| 模块 | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | 规范的 XAX 存储：生命周期、挂钩、设置界面和诊断，由 XAX android-libxposed 目标编译为 DEX |
| 策略 | [policy/](policy/) | 由 BBC 编译为 ARM64 stdio 可执行文件的 Brainfuck 策略，打包为 `lib/arm64-v8a/libppepolicy.so`（[ABI](policy/ABI.md)）。它不是 JNI 库 |
| DexKit 依赖 | [module/deps/](module/deps/) 和 `module/libdexkit.so` | 预编译的依赖 DEX 和 ARM64 JNI，在运行时查找混淆后的相册类；[声明](docs/THIRD_PARTY.md) |
| 资源 | [module/res/](module/res/) | 名称、描述、自适应图标，以及十种语言的界面文字（`values*/`） |

## 翻译

界面文字使用标准的 Android 字符串资源：英文位于 `module/res/values/ui_strings.xml`，每种语言各有一个
`module/res/values-*/strings.xml`。要修正翻译，请在该语言的文件中编辑同一 `name` 的字符串。要添加语言，
请新建 `values-<locale>` 文件夹并包含所有 `ppe_*` 键。缺少的键会回退为英文。

## 构建

本仓库中只有 Brainfuck 和规范 XAX 属于源代码。构建使用 [toolchain.lock.json](toolchain.lock.json) 中固定版本的
XAX SDK；常规构建工具放在仓库之外。[复现构建](docs/REPRODUCE.md)（英文）列出了确切步骤：验证存储，用 XAX
构建策略可执行文件和模块 APK，用 aapt2 添加资源，然后签名。[SHA256SUMS](SHA256SUMS) 列出所有保留的文件。

## 证据

[状态](report/STATUS.md) 区分了在设备上检查过的、离线检查过的和尚未测试的内容。[证据索引](docs/EVIDENCE.md) 链接所有报告（英文）。

## 致谢

- [XAX](https://github.com/MrxSiN/XAX) — 语言、语义存储和 Android 目标
- [BBC](https://github.com/MrxSiN/BBC) — Brainfuck 编译器
- [DexKit](https://github.com/LuckyPray/DexKit) — 运行时 DEX 查找（[依赖声明](docs/THIRD_PARTY.md)）
- [libxposed](https://github.com/libxposed/api) 和 Vector

请参阅 [署名](docs/ATTRIBUTION.md)。Pixel Photos Evolved 与 Google 无关，也未获得 Google 认可。
Google Photos 和 Pixel 是 Google LLC 的商标。
