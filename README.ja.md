<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**元の画質で無制限バックアップ、Video Boost にも対応**

Google フォト → プロフィール写真 → **Pixel Photos Evolved**

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [Español](README.es.md) · [Português](README.pt.md) · [Русский](README.ru.md) · **日本語** · [한국어](README.ko.md) · [Bahasa Indonesia](README.id.md) · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#互換性)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#ビルド)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **Android 17（API 37）、Pixel 8 Pro、Vector 2.2 / libxposed API 102 上の Google フォト
> 7.98.0.1007591100（`52591217`）でテスト済み。** PPE はフックするフォトのクラスをすべて DexKit で
> 見つけるため、ほとんどのフォトの更新ではモジュールを再ビルドする必要がありません。クラスが見つからない
> 場合、フォトは本来の動作を維持し、**互換性と診断** に利用できない機能が表示されます。
> 詳しくは [DexKit レポート](report/dexkit-1.4.1.md)（英語）をご覧ください。

> [!IMPORTANT]
> バックアップの対象や保存容量の計算方法は、Google がサーバー側で決定します。このモジュールは、
> このスマートフォン上の Google フォトが報告する内容を変更するだけです。無制限の保存容量は保証できず、
> 使用すると Google の利用規約に抵触する可能性があります。バックアップのオプションを有効にした後は、
> アカウントの保存容量を確認してください。

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>プロフィール メニュー内の専用カード</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>Google フォトの設定と同じデザイン</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>互換性と診断</sub></td>
</tr>
</table>

## この設計の理由

多くのモジュールは別の設定アプリを用意しますが、このモジュールにはありません。ランチャーのアイコンも
設定アクティビティもなく、Google フォトのプロフィール メニューにある専用カードからページを開きます。
カードは **Google フォトのデータ** の上に、それとは別に表示されます。フォト自体のフォント、色、スイッチ、
アニメーションを使い、設定はフォト自体のデータ ディレクトリに保存します。

|  | |
|---|---|
| 🧭 **いつもの場所に** | プロフィール写真 → Pixel Photos Evolved。戻るとメニューに戻ります。 |
| 🎨 **フォトと同じ見た目** | フォトの文字スケール、カードの色、Material スイッチ、ページ切り替えの強調イージング。ライトテーマとダークテーマはフォトに従います。 |
| 🌐 **あなたの言語で** | English、简体中文、繁體中文、Español、Português、Русский、日本語、한국어、Bahasa Indonesia、Bahasa Melayu に対応。スマートフォンの言語、または Google フォトに設定したアプリの言語に従います。 |
| 🛡 **実行中のフォトを把握** | 各フックは、インストール前に実行中のフォトのビルドに対して確認されます。フックがない、または変わっている場合は、その機能だけが無効になります。 |
| 🧠 **Brainfuck によるポリシー** | バックアップと Video Boost の判断は、コンパイル済みの Brainfuck プログラム（ARM64）が、小さな固定 ABI を通じて行います。 |
| 🎞 **元の動画データ** | 回収では安全なコピーを残し、選択したクラウドの動画とそのゴミ箱のコピーだけを削除して、同じデータを再エンコードせずに再アップロードします。 |
| 🔒 **範囲を限定** | `com.google.android.apps.photos` のみ。システム全体へのフックはなく、モジュール自体に root は不要です。 |

---

## 機能

<details open>
<summary><b>☁️ バックアップ</b></summary>
<br>

| 設定 | 内容 |
|---|---|
| **無制限の元の画質** | Google フォト内で Pixel XL（2016）として認識させ、Pixel XL のバックアップ条件を適用させます。スマートフォン本来の編集機能はそのまま使えます。 |
| **無制限の保存容量の節約画質** | 代わりに、選択した旧型 Pixel として認識させます。この設定と「無制限の元の画質」は同時にオンにできません。バックアップの画質が「保存容量の節約画質」の場合にのみ適用されます。 |

識別情報の変更は Google フォトの起動時に適用されます。変更すると PPE が **今すぐ再起動** を表示し、1 回のタップでフォトを閉じて開き直せます。回収の実行中は表示されません。

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| 設定 | 内容 |
|---|---|
| **Video Boost** | Video Boost で録画した動画を検出し、スマートフォン本来の識別情報でアップロードします。これにより Google が動画を処理でき、他のバックアップはバックアップ用の識別情報のままになります。Video Boost で録画できるスマートフォン（Pixel 8 Pro、Pixel 9–11 Pro シリーズ、XL と Fold を含む）でのみ利用できます。 |
| **Video Boost のストレージ回収** | 容量を使用しているブースト済みの動画をスキャンし、選択して回収します。PPE は動画を 1 本ずつダウンロードし、クラウドのコピーを（ゴミ箱からも）削除して、バックアップ設定に従って再アップロードします。再アップロードした動画は Video Boost のタグとリンクを失います。 |

無制限バックアップのオプションがオンでも、Video Boost で処理された動画は Google アカウントの保存容量に
含まれます。アップロードの識別と振り分けについては [Video Boost](docs/VIDEO_BOOST.md)（英語）をご覧ください。

ローカルの開発ビルドは **1.1.0 / 36** です。[回収ページ](docs/VIDEO_BOOST_RECLAIM.md)（英語）は確認を
求めた後、動画を 1 本ずつ処理します: ダウンロード → 確認 → クラウドのコピーを削除 → ゴミ箱から削除 →
再アップロード → 容量を確認。進行状況カードに現在の動画とステップが表示され、履歴に過去の結果が残ります。
各動画の処理が完了するまで安全なコピーがスマートフォンに残り、中断した処理は再開できます。スキャンはフォトの
キャッシュを使うため、ライブラリ全体を網羅しているとは限りません。詳しくは
[回収レポート](report/reclaim-7.98-1.3.2.md)（英語）をご覧ください。

</details>

---

## 互換性

| Android | Google フォト | デバイス | 状態 |
|---|---|---|---|
| 17（API 37） | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0: すべてのクラスを DexKit で検出、バックアップのプローブに合格、テスト動画で回収を確認済み（1.3.2） |
| 17 QPR1（CP3A.261005.005） | 7.97.0.1000520730 | Pixel 8 Pro | このビルドの DEX で DexKit ルールを検証済み。実機での最終テストは 1.2.2-dev |

- **有効化の条件。** 起動時に、Android API 37、ARM64、そして必要なすべてのクラスを DexKit が見つけたかを
  確認します。条件を満たさない場合、動作を変更するものは何もインストールしません。
- **機能ごとのフック。** バックアップと Video Boost のフックは個別に検出・確認されます。一方がない場合、
  診断のその行に *互換性なし: Google フォト …* と表示され、もう一方は引き続き動作します。
- **互換性と診断** には、モジュールのバージョン、Android、デバイス、Google フォトのバージョン、libxposed API と
  フレームワーク、各機能の状態（互換性あり、無効、利用不可）が表示されます。**診断ログ** は
  `adb logcat -s PixelPhotosEvolved` に詳細を追加します。ログは英語のままです。

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>モジュールとシステム</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>機能の互換性</sub></td>
</tr>
</table>

---

## 要件

- Android 17（API 37）、ARM64。APK は Android 13 以降にインストールできますが、フックが有効になるのは Android 17 のみです
- **libxposed API 102** に対応した Xposed フレームワーク（Vector 2.2 でテスト済み）
- Google フォト 7.98.0.1007591100（テスト済み）。DexKit ルールで必要なクラスをすべて解決できれば、他のビルドでも動作します（結果は「互換性と診断」に表示されます）

## インストール

1. [最新リリース](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest) または
   [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved) から APK をインストールします。
2. Xposed マネージャーで **Pixel Photos Evolved** を有効にし、スコープを **Google フォト**
   （`com.google.android.apps.photos`）に設定します。
3. Google フォトを強制停止してから開き直します。
4. プロフィール写真 → **Pixel Photos Evolved**。

無効にするには、Xposed マネージャーでモジュールを無効にして Google フォトを再起動します。詳しくは
[インストールとトラブルシューティング](docs/INSTALLATION_AND_TROUBLESHOOTING.md)（英語）をご覧ください。

リリース版の APK はここでビルドされ、[リリース ワークフロー](.github/workflows/release.yml) がリリース鍵で
再署名し、Xposed Modules Repository にも反映します。[module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk)
は、再現用に XAX の公開テスト鍵で署名した同じビルドです。

## 仕組み

| 構成要素 | 場所 | 役割 |
|---|---|---|
| モジュール | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | 正規の XAX ストア。ライフサイクル、フック、設定画面、診断を含み、XAX の android-libxposed ターゲットで DEX に変換されます |
| ポリシー | [policy/](policy/) | BBC で ARM64 の stdio 実行ファイルにコンパイルした Brainfuck ポリシー。`lib/arm64-v8a/libppepolicy.so` としてパッケージされます（[ABI](policy/ABI.md)）。JNI ライブラリではありません |
| DexKit 依存関係 | [module/deps/](module/deps/) と `module/libdexkit.so` | 実行時に難読化されたフォトのクラスを見つける、コンパイル済みの依存 DEX と ARM64 JNI。[通知](docs/THIRD_PARTY.md) |
| リソース | [module/res/](module/res/) | 名前、説明、アダプティブ アイコン、10 言語の UI テキスト（`values*/`） |

## 翻訳

UI テキストは Android 標準の文字列リソースにあります。英語は `module/res/values/ui_strings.xml`、
各言語は `module/res/values-*/strings.xml` です。翻訳を修正するには、その言語のファイルで同じ `name`
の文字列を編集します。言語を追加するには、すべての `ppe_*` キーを含む `values-<locale>` フォルダを作成します。
キーがない場合は英語で表示されます。

## ビルド

このリポジトリのソースコードは Brainfuck と正規の XAX のみです。ビルドには [toolchain.lock.json](toolchain.lock.json)
で固定された XAX SDK を使用し、一般的なビルドツールはリポジトリの外に置きます。
[ビルドの再現](docs/REPRODUCE.md)（英語）に正確な手順があります: ストアの検証、XAX によるポリシー実行ファイルと
モジュール APK のビルド、aapt2 によるリソースの追加、署名。[SHA256SUMS](SHA256SUMS) に保持しているすべての
ファイルが記載されています。

## 検証記録

[ステータス](report/STATUS.md) では、実機で確認したこと、オフラインで確認したこと、未テストのことを区別しています。
[検証記録の索引](docs/EVIDENCE.md) からすべてのレポート（英語）にアクセスできます。

## クレジット

- [XAX](https://github.com/MrxSiN/XAX) — 言語、セマンティック ストア、Android ターゲット
- [BBC](https://github.com/MrxSiN/BBC) — Brainfuck コンパイラ
- [DexKit](https://github.com/LuckyPray/DexKit) — 実行時の DEX 検索（[依存関係の通知](docs/THIRD_PARTY.md)）
- [libxposed](https://github.com/libxposed/api) と Vector

[帰属表示](docs/ATTRIBUTION.md) をご覧ください。Pixel Photos Evolved は Google とは無関係であり、Google の
承認を受けていません。Google フォトと Pixel は Google LLC の商標です。
