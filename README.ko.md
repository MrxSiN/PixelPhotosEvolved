<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**원본 화질 무제한 백업, Video Boost 지원**

Google 포토 → 프로필 사진 → **Pixel Photos Evolved**

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [Español](README.es.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · **한국어** · [Bahasa Indonesia](README.id.md) · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#호환성)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#빌드)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **Android 17(API 37), Pixel 8 Pro, Vector 2.2 / libxposed API 102에서 Google 포토
> 7.98.0.1007591100(`52591217`)으로 테스트했습니다.** PPE는 후킹하는 모든 포토 클래스를 DexKit으로
> 찾기 때문에 대부분의 포토 업데이트에서 모듈을 새로 빌드할 필요가 없습니다. 클래스를 찾지 못하면 포토는
> 기본 동작을 유지하며, **호환성 및 진단**에서 사용할 수 없는 기능을 확인할 수 있습니다.
> 자세한 내용은 [DexKit 보고서](report/dexkit-1.4.1.md)(영문)를 참고하세요.

> [!IMPORTANT]
> 백업 대상 여부와 저장용량 계산 방식은 Google이 서버에서 결정합니다. 이 모듈은 이 휴대전화의 Google
> 포토가 보고하는 내용만 변경합니다. 무제한 저장용량을 보장할 수 없으며, 사용 시 Google 서비스 약관에
> 위배될 수 있습니다. 백업 옵션을 사용 설정한 후에는 계정의 저장용량을 확인하세요.

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>프로필 메뉴의 전용 카드</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>Google 포토 설정과 같은 디자인</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>호환성 및 진단</sub></td>
</tr>
</table>

## 이렇게 설계한 이유

대부분의 모듈은 별도의 설정 앱을 제공합니다. 이 모듈에는 그런 앱이 없습니다. 런처 아이콘도, 설정
액티비티도 없습니다. 페이지는 Google 포토 프로필 메뉴의 전용 카드에서 열리며, 이 카드는
**Google 포토의 내 데이터** 위에 별도로 표시됩니다. 포토의 글꼴, 색상, 스위치, 애니메이션을 그대로 사용하고
설정은 포토의 데이터 디렉터리에 저장합니다.

|  | |
|---|---|
| 🧭 **익숙한 위치에** | 프로필 사진 → Pixel Photos Evolved. 뒤로를 누르면 메뉴로 돌아갑니다. |
| 🎨 **포토와 같은 모습** | 포토의 글꼴 크기 체계, 카드 색상, Material 스위치, 페이지 전환의 강조 이징. 라이트 및 다크 테마는 포토를 따릅니다. |
| 🌐 **사용자의 언어 지원** | English, 简体中文, 繁體中文, Español, Português, Русский, 日本語, 한국어, Bahasa Indonesia, Bahasa Melayu. 휴대전화 언어 또는 Google 포토에 설정한 앱 언어를 따릅니다. |
| 🛡 **실행 중인 포토를 확인** | 모든 후크는 설치 전에 실행 중인 포토 빌드에 대해 확인됩니다. 후크가 없거나 변경된 경우 해당 기능만 사용 중지됩니다. |
| 🧠 **Brainfuck 정책** | 백업 및 Video Boost 판단은 컴파일된 Brainfuck 프로그램(ARM64)이 작은 고정 ABI를 통해 수행합니다. |
| 🎞 **원본 동영상 데이터** | 회수 시 안전한 사본을 보관하고, 선택한 클라우드 동영상과 휴지통 사본만 삭제한 후 같은 데이터를 다시 인코딩하지 않고 업로드합니다. |
| 🔒 **범위 제한** | `com.google.android.apps.photos`에만 적용됩니다. 시스템 전체 후크가 없으며 모듈에 루트가 필요하지 않습니다. |

---

## 기능

<details open>
<summary><b>☁️ 백업</b></summary>
<br>

| 설정 | 기능 |
|---|---|
| **무제한 원본 화질** | Google 포토 안에서 Pixel XL(2016)로 인식되게 하여 포토가 Pixel XL 백업 조건을 제공하게 합니다. 휴대전화 자체의 편집 기능은 계속 사용할 수 있습니다. |
| **무제한 저장용량 절약형** | 대신 선택한 구형 Pixel로 인식되게 합니다. 이 설정과 무제한 원본 화질은 동시에 켤 수 없습니다. 백업 화질이 저장용량 절약형일 때만 적용됩니다. |

기기 정보 변경은 Google 포토가 시작될 때 적용됩니다. 변경하면 PPE에 **지금 다시 시작**이 표시되며, 한 번 탭하여 포토를 닫고 다시 열 수 있습니다. 회수가 진행 중일 때는 표시되지 않습니다.

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| 설정 | 기능 |
|---|---|
| **Video Boost** | Video Boost로 녹화한 동영상을 감지하여 휴대전화의 실제 기기 정보로 업로드합니다. 따라서 Google이 해당 동영상을 처리할 수 있고, 다른 백업은 백업용 기기 정보를 유지합니다. Video Boost 녹화를 지원하는 휴대전화(Pixel 8 Pro 및 Pixel 9–11 Pro 시리즈, XL 및 Fold 모델 포함)에서만 사용할 수 있습니다. |
| **Video Boost 저장용량 회수** | 저장용량을 사용하는 부스트된 동영상을 검색하고 선택하여 회수합니다. PPE는 각 동영상을 다운로드하고 클라우드 사본을 삭제(휴지통 포함)한 다음 백업 설정에 따라 다시 업로드합니다. 다시 업로드한 동영상은 Video Boost 태그와 링크를 잃습니다. |

무제한 백업 옵션을 사용 중이어도 Video Boost로 처리된 동영상은 Google 계정 저장용량에 포함됩니다.
업로드를 식별하고 전송하는 방법은 [Video Boost](docs/VIDEO_BOOST.md)(영문)를 참고하세요.

로컬 개발 빌드는 **1.1.1 / 37**입니다. [회수 페이지](docs/VIDEO_BOOST_RECLAIM.md)(영문)는 확인을 요청한 후
동영상을 하나씩 처리합니다: 다운로드 → 확인 → 클라우드 사본 삭제 → 휴지통에서 삭제 → 다시 업로드 →
저장용량 확인. 진행 상황 카드에 현재 동영상과 단계가 표시되고, 기록 목록에 이전 결과가 남습니다. 각 동영상이
완료될 때까지 안전한 사본이 휴대전화에 보관되며, 중단된 작업은 재개할 수 있습니다. 검색은 포토의 캐시를
사용하므로 전체 라이브러리를 포함한다고 보장할 수 없습니다. 자세한 내용은
[회수 보고서](report/reclaim-7.98-1.3.2.md)(영문)를 참고하세요.

</details>

---

## 호환성

| Android | Google 포토 | 기기 | 상태 |
|---|---|---|---|
| 17(API 37) | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0: 모든 클래스를 DexKit으로 찾음, 백업 확인 통과, 테스트 동영상으로 회수 확인(1.3.2) |
| 17 QPR1(CP3A.261005.005) | 7.97.0.1000520730 | Pixel 8 Pro | 이 빌드의 DEX로 DexKit 규칙 검증; 기기에서 마지막으로 테스트한 버전은 1.2.2-dev |

- **사용 조건.** 시작 시 모듈은 Android API 37, ARM64, 그리고 DexKit이 필요한 모든 클래스를 찾았는지
  확인합니다. 그렇지 않으면 동작을 바꾸는 어떤 것도 설치하지 않습니다.
- **기능별 후크.** 백업과 Video Boost 후크는 따로 찾고 확인합니다. 하나가 없으면 진단의 해당 행에
  *호환되지 않음: Google 포토 …*가 표시되고, 다른 하나는 계속 작동합니다.
- **호환성 및 진단**에는 모듈 버전, Android, 기기, Google 포토 버전, libxposed API와 프레임워크, 각 기능의
  상태(호환됨, 사용 중지됨, 사용할 수 없음)가 표시됩니다. **진단 로깅**은 `adb logcat -s PixelPhotosEvolved`에
  세부정보를 추가합니다. 로그는 영어로 유지됩니다.

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>모듈 및 시스템</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>기능 호환성</sub></td>
</tr>
</table>

---

## 요구사항

- Android 17(API 37), ARM64. APK는 Android 13부터 설치되지만 후크는 Android 17에서만 사용 설정됩니다
- **libxposed API 102**를 지원하는 Xposed 프레임워크(Vector 2.2로 테스트)
- Google 포토 7.98.0.1007591100(테스트됨). DexKit 규칙이 필요한 모든 클래스를 찾으면 다른 빌드에서도 작동합니다(결과는 호환성 및 진단에 표시됨)

## 설치

1. [최신 릴리스](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest) 또는
   [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved)에서 APK를 설치합니다.
2. Xposed 관리자에서 **Pixel Photos Evolved**를 사용 설정하고 범위를 **Google 포토**
   (`com.google.android.apps.photos`)로 지정합니다.
3. Google 포토를 강제 종료한 후 다시 엽니다.
4. 프로필 사진 → **Pixel Photos Evolved**.

사용 중지하려면 Xposed 관리자에서 모듈을 사용 중지하고 Google 포토를 다시 시작하세요. 자세한 내용은
[설치 및 문제 해결](docs/INSTALLATION_AND_TROUBLESHOOTING.md)(영문)을 참고하세요.

릴리스 APK는 여기에서 빌드되며 [릴리스 워크플로](.github/workflows/release.yml)가 릴리스 키로 다시 서명하고
Xposed Modules Repository에도 반영합니다. [module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk)는
재현용으로 XAX 공개 테스트 키로 서명한 같은 빌드입니다.

## 작동 방식

| 구성 요소 | 위치 | 역할 |
|---|---|---|
| 모듈 | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | 표준 XAX 저장소: 수명 주기, 후크, 설정 UI, 진단. XAX android-libxposed 타깃이 DEX로 변환 |
| 정책 | [policy/](policy/) | BBC가 ARM64 stdio 실행 파일로 컴파일한 Brainfuck 정책으로, `lib/arm64-v8a/libppepolicy.so`로 패키징됨([ABI](policy/ABI.md)). JNI 라이브러리가 아님 |
| DexKit 종속 항목 | [module/deps/](module/deps/) 및 `module/libdexkit.so` | 런타임에 난독화된 포토 클래스를 찾는 사전 컴파일된 종속 DEX 및 ARM64 JNI; [고지](docs/THIRD_PARTY.md) |
| 리소스 | [module/res/](module/res/) | 이름, 설명, 적응형 아이콘, 10개 언어의 UI 텍스트(`values*/`) |

## 번역

UI 텍스트는 Android 표준 문자열 리소스에 있습니다. 영어는 `module/res/values/ui_strings.xml`, 각 언어는
`module/res/values-*/strings.xml`입니다. 번역을 수정하려면 해당 언어 파일에서 같은 `name`의 문자열을
편집하세요. 언어를 추가하려면 모든 `ppe_*` 키를 포함한 `values-<locale>` 폴더를 만드세요. 없는 키는 영어로
표시됩니다.

## 빌드

이 저장소의 소스 코드는 Brainfuck과 표준 XAX뿐입니다. 빌드에는 [toolchain.lock.json](toolchain.lock.json)에
고정된 XAX SDK를 사용하며, 일반 빌드 도구는 저장소 밖에 둡니다. [빌드 재현](docs/REPRODUCE.md)(영문)에 정확한
단계가 있습니다: 저장소 검증, XAX로 정책 실행 파일과 모듈 APK 빌드, aapt2로 리소스 추가, 서명.
[SHA256SUMS](SHA256SUMS)에 보관된 모든 파일이 나열되어 있습니다.

## 검증 자료

[상태](report/STATUS.md)는 기기에서 확인한 내용, 오프라인으로 확인한 내용, 테스트하지 않은 내용을 구분합니다.
[검증 자료 색인](docs/EVIDENCE.md)에서 모든 보고서(영문)로 이동할 수 있습니다.

## 크레딧

- [XAX](https://github.com/MrxSiN/XAX) — 언어, 시맨틱 저장소, Android 타깃
- [BBC](https://github.com/MrxSiN/BBC) — Brainfuck 컴파일러
- [DexKit](https://github.com/LuckyPray/DexKit) — 런타임 DEX 검색([종속 항목 고지](docs/THIRD_PARTY.md))
- [libxposed](https://github.com/libxposed/api) 및 Vector

[저작자 표시](docs/ATTRIBUTION.md)를 참고하세요. Pixel Photos Evolved는 Google과 관련이 없으며 Google의 보증을
받지 않았습니다. Google 포토와 Pixel은 Google LLC의 상표입니다.
