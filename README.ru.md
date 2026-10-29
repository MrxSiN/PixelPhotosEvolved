<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**Безлимитное резервное копирование в исходном качестве, с Video Boost**

Google Фото → фото профиля → **Pixel Photos Evolved**.

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [Español](README.es.md) · [Português](README.pt.md) · **Русский** · [日本語](README.ja.md) · [한국어](README.ko.md) · [Bahasa Indonesia](README.id.md) · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#совместимость)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#сборка)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **Проверено с Google Фото 7.98.0.1007591100 (`52591217`) на Android 17 (API 37), Pixel 8 Pro,
> Vector 2.2 / libxposed API 102.** PPE находит через DexKit каждый класс Фото, который перехватывает,
> поэтому большинство обновлений Фото не требуют новой сборки модуля. Если класс не найден, Фото
> работают как обычно, а раздел **Совместимость и диагностика** показывает, что недоступно.
> Подробнее в [отчёте о DexKit](report/dexkit-1.4.1.md) (на английском).

> [!IMPORTANT]
> Google на своих серверах решает, что можно копировать и как считается хранилище. Этот модуль меняет
> то, что сообщают Google Фото на этом телефоне. Он не гарантирует безлимитное хранилище, а его
> использование может нарушать условия использования Google. После включения любого варианта
> резервного копирования проверьте хранилище аккаунта.

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>Своя карточка в меню профиля</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>В стиле настроек Google Фото</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Совместимость и диагностика</sub></td>
</tr>
</table>

## Почему так устроено

Большинство модулей дают вам отдельное приложение настроек. У этого его нет: ни значка в лаунчере, ни
activity настроек. Его страница открывается из собственной карточки в меню профиля Google Фото, над
пунктом **Ваши данные в Google Фото** и отдельно от него. Модуль использует шрифты, цвета, переключатели
и анимации самих Фото и хранит настройки в каталоге данных Фото.

|  | |
|---|---|
| 🧭 **Там, где вы уже находитесь** | Фото профиля → Pixel Photos Evolved. «Назад» возвращает в меню. |
| 🎨 **Выглядит как Фото** | Типографика Фото, цвета карточек, переключатель Material и выразительная анимация переходов. Светлая и тёмная темы следуют за Фото. |
| 🌐 **Говорит на вашем языке** | English, 简体中文, 繁體中文, Español, Português, Русский, 日本語, 한국어, Bahasa Indonesia и Bahasa Melayu. Следует языку телефона или языку, выбранному для Google Фото. |
| 🛡 **Знает, в каких Фото работает** | Каждый перехват проверяется на запущенной сборке Фото до установки. Отсутствующий или изменённый перехват отключает только свою функцию. |
| 🧠 **Логика на Brainfuck** | Решения о резервном копировании и Video Boost принимает скомпилированная программа на Brainfuck (ARM64) через небольшой фиксированный ABI. |
| 🎞 **Исходные байты видео** | При освобождении места сохраняется безопасная копия, удаляются только выбранное видео в облаке и его копия в корзине, затем те же байты загружаются заново без перекодирования. |
| 🔒 **Ограниченная область** | Только `com.google.android.apps.photos`. Никаких системных перехватов; модулю не нужен root. |

---

## Функции

<details open>
<summary><b>☁️ Резервное копирование</b></summary>
<br>

| Настройка | Что делает |
|---|---|
| **Безлимитное исходное качество** | Применяет внутри Google Фото идентификацию Pixel XL (2016), чтобы Фото предлагали условия копирования Pixel XL. Функции редактирования вашего телефона остаются доступны. |
| **Безлимитная экономия места** | Вместо этого применяет идентификацию выбранного старого Pixel. Эта настройка и «Безлимитное исходное качество» выключают друг друга. Фото учитывают её только при качестве копирования «Экономия места». |

Изменения идентификации применяются при запуске Google Фото. После изменения PPE предлагает кнопку **Перезапустить**, которая закрывает и снова открывает Фото одним нажатием. Во время освобождения места она не предлагается.

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| Настройка | Что делает |
|---|---|
| **Video Boost** | Распознаёт записи Video Boost и загружает их с настоящей идентификацией телефона, чтобы Google мог их обработать, а остальные копии сохраняли идентификацию для резервного копирования. Только на телефонах с записью Video Boost: Pixel 8 Pro и серия Pixel 9–11 Pro, включая модели XL и Fold. |
| **Освобождение места Video Boost** | Найдите улучшенные видео, занимающие место, выберите их и освободите место: PPE скачивает каждое видео, удаляет облачную копию (в том числе из корзины) и загружает его заново с вашими настройками резервного копирования. Повторно загруженные видео теряют метки и связи Video Boost. |

Видео, обработанные Video Boost, занимают место в аккаунте Google, даже если включено безлимитное
резервное копирование. Как распознаётся и направляется загрузка, описано в
[Video Boost](docs/VIDEO_BOOST.md) (на английском).

Локальная сборка для разработки — **1.1.0 / 36**. [Страница освобождения места](docs/VIDEO_BOOST_RECLAIM.md)
(на английском) запрашивает подтверждение и обрабатывает видео по одному: скачивание → проверка →
удаление облачной копии → очистка корзины → повторная загрузка → проверка хранилища. Карточка прогресса
показывает текущее видео и шаг, а история хранит прошлые результаты. Безопасная копия остаётся на
телефоне, пока видео не будет обработано, а прерванный процесс можно продолжить. Поиск использует кеш
Фото, поэтому не гарантирует охват всей библиотеки. Подробнее в
[отчёте об освобождении места](report/reclaim-7.98-1.3.2.md) (на английском).

</details>

---

## Совместимость

| Android | Google Фото | Устройство | Состояние |
|---|---|---|---|
| 17 (API 37) | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0: все классы найдены через DexKit, проверка резервного копирования пройдена, освобождение места проверено на тестовом видео (1.3.2) |
| 17 QPR1 (CP3A.261005.005) | 7.97.0.1000520730 | Pixel 8 Pro | Правила DexKit проверены на DEX этой сборки; последняя проверка на устройстве — 1.2.2-dev |

- **Условие включения.** При запуске модуль проверяет Android API 37, ARM64 и что DexKit нашёл все нужные
  классы. Иначе он не устанавливает ничего, что меняет поведение.
- **Перехваты по функциям.** Перехваты резервного копирования и Video Boost ищутся и проверяются
  отдельно. Если одного нет, его строка в диагностике показывает *Несовместимо с Google Фото …*, а
  другая функция продолжает работать.
- **Совместимость и диагностика** показывает версию модуля, Android, устройство, версию Google Фото,
  API libxposed и фреймворк, а также состояние каждой функции: совместимо, отключено или недоступно.
  **Журнал диагностики** добавляет подробности в `adb logcat -s PixelPhotosEvolved`. Журнал остаётся
  на английском.

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Модуль и система</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>Совместимость функций</sub></td>
</tr>
</table>

---

## Требования

- Android 17 (API 37), ARM64. APK устанавливается начиная с Android 13, но перехваты включаются только на Android 17
- Фреймворк Xposed с **libxposed API 102** (проверено с Vector 2.2)
- Google Фото 7.98.0.1007591100 (проверено); другие сборки работают, если правила DexKit находят все нужные классы (результат показан в разделе «Совместимость и диагностика»)

## Установка

1. Установите APK из [последнего выпуска](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest)
   или из [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved).
2. Включите **Pixel Photos Evolved** в менеджере Xposed с областью **Google Фото**
   (`com.google.android.apps.photos`).
3. Остановите Google Фото и откройте снова.
4. Фото профиля → **Pixel Photos Evolved**.

Чтобы выключить модуль, отключите его в менеджере Xposed и перезапустите Google Фото. Подробнее в
[установке и устранении неполадок](docs/INSTALLATION_AND_TROUBLESHOOTING.md) (на английском).

APK выпусков собираются здесь и переподписываются ключом выпуска в
[процессе выпуска](.github/workflows/release.yml), который также публикует каждый выпуск в Xposed
Modules Repository. [module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk) — та
же сборка, подписанная публичным тестовым ключом XAX, для воспроизведения.

## Как это работает

| Часть | Где | Что делает |
|---|---|---|
| Модуль | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | Канонический store XAX: жизненный цикл, перехваты, интерфейс настроек и диагностика, компилируется в DEX целью android-libxposed XAX |
| Логика | [policy/](policy/) | Логика на Brainfuck, скомпилированная BBC в исполняемый файл ARM64 со stdio и упакованная как `lib/arm64-v8a/libppepolicy.so` ([ABI](policy/ABI.md)). Это не JNI-библиотека |
| Зависимость DexKit | [module/deps/](module/deps/) и `module/libdexkit.so` | Предсобранный DEX зависимости и JNI ARM64, которые находят обфусцированные классы Фото во время работы; [уведомления](docs/THIRD_PARTY.md) |
| Ресурсы | [module/res/](module/res/) | Название, описание, адаптивный значок и текст интерфейса на десяти языках (`values*/`) |

## Переводы

Текст интерфейса хранится в стандартных строковых ресурсах Android: английский — в
`module/res/values/ui_strings.xml`, и по одному файлу `module/res/values-*/strings.xml` на каждый язык.
Чтобы исправить перевод, измените строку с тем же `name` в файле нужного языка. Чтобы добавить язык,
создайте папку `values-<locale>` со всеми ключами `ppe_*`. Отсутствующие ключи показываются на английском.

## Сборка

Исходный код в этом репозитории — только Brainfuck и канонический XAX. Сборка использует SDK XAX,
закреплённый в [toolchain.lock.json](toolchain.lock.json); обычные инструменты сборки находятся вне
репозитория. [Воспроизведение сборки](docs/REPRODUCE.md) (на английском) описывает точные шаги:
проверить store, собрать исполняемый файл логики и APK модуля с помощью XAX, добавить ресурсы через
aapt2 и подписать. [SHA256SUMS](SHA256SUMS) перечисляет все сохранённые файлы.

## Подтверждения

[Состояние](report/STATUS.md) разделяет проверенное на устройстве, проверенное офлайн и непроверенное.
[Указатель подтверждений](docs/EVIDENCE.md) ссылается на все отчёты (на английском).

## Благодарности

- [XAX](https://github.com/MrxSiN/XAX) — язык, семантическое хранилище и цель Android
- [BBC](https://github.com/MrxSiN/BBC) — компилятор Brainfuck
- [DexKit](https://github.com/LuckyPray/DexKit) — поиск в DEX во время работы ([уведомления о зависимостях](docs/THIRD_PARTY.md))
- [libxposed](https://github.com/libxposed/api) и Vector

См. [атрибуцию](docs/ATTRIBUTION.md). Pixel Photos Evolved не связан с Google и не одобрен Google.
Google Фото и Pixel — товарные знаки Google LLC.
