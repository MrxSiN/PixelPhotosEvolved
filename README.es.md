<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**Copia de seguridad ilimitada en calidad original, con Video Boost**

Google Fotos → tu foto de perfil → **Pixel Photos Evolved**.

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · **Español** · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Bahasa Indonesia](README.id.md) · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#compatibilidad)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#compilación)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **Probado con Google Fotos 7.98.0.1007591100 (`52591217`) en Android 17 (API 37), Pixel 8 Pro,
> Vector 2.2 / libxposed API 102.** PPE encuentra con DexKit cada clase de Fotos que intercepta, así
> que la mayoría de las actualizaciones de Fotos no necesitan una nueva versión del módulo. Si no
> encuentra una clase, Fotos mantiene su comportamiento y **Compatibilidad y diagnóstico** muestra qué
> no está disponible. Consulta el [informe de DexKit](report/dexkit-1.4.1.md) (en inglés).

> [!IMPORTANT]
> Google decide en sus servidores qué se puede copiar y cómo se cuenta el almacenamiento. Este módulo
> cambia lo que informa Google Fotos en este teléfono. No puede garantizar almacenamiento ilimitado y
> usarlo puede infringir las condiciones de servicio de Google. Revisa el almacenamiento de tu cuenta
> después de activar cualquier opción de copia de seguridad.

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>Su propia tarjeta en el menú del perfil</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>Con el estilo de los ajustes de Google Fotos</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Compatibilidad y diagnóstico</sub></td>
</tr>
</table>

## Por qué funciona así

La mayoría de los módulos te dan una segunda app de ajustes. Este no: no tiene icono en el launcher ni
actividad de ajustes. Su página se abre desde su propia tarjeta en el menú del perfil de Google Fotos,
encima de **Tus datos en Google Fotos** y separada de ella. Usa las fuentes, colores, interruptores y
animaciones de Fotos, y guarda sus ajustes en el directorio de datos de Fotos.

|  | |
|---|---|
| 🧭 **Donde ya estás** | Foto de perfil → Pixel Photos Evolved. Atrás vuelve al menú. |
| 🎨 **Se ve como Fotos** | La escala tipográfica de Fotos, los colores de las tarjetas, el interruptor Material y su curva enfatizada en las transiciones. Los temas claro y oscuro siguen a Fotos. |
| 🌐 **Habla tu idioma** | English, 简体中文, 繁體中文, Español, Português, Русский, 日本語, 한국어, Bahasa Indonesia y Bahasa Melayu. Sigue el idioma del teléfono o el idioma de app elegido para Google Fotos. |
| 🛡 **Conoce el Fotos en el que se ejecuta** | Cada hook se comprueba con la versión de Fotos en ejecución antes de instalarse. Si un hook falta o cambia, solo se desactiva su función. |
| 🧠 **Política en Brainfuck** | Las decisiones de copia de seguridad y Video Boost las toma un programa Brainfuck compilado (ARM64), llamado con una ABI pequeña y fija. |
| 🎞 **Bytes de vídeo originales** | La recuperación guarda una copia segura, elimina solo el vídeo de la nube elegido y su copia en la papelera, y vuelve a subir los mismos bytes sin recodificar. |
| 🔒 **Acotado** | Solo `com.google.android.apps.photos`. Sin hooks en todo el sistema; el módulo no necesita root. |

---

## Funciones

<details open>
<summary><b>☁️ Copia de seguridad</b></summary>
<br>

| Ajuste | Qué hace |
|---|---|
| **Calidad original ilimitada** | Aplica la identidad de un Pixel XL (2016) dentro de Google Fotos, para que Fotos ofrezca las condiciones de copia del Pixel XL. Las funciones de edición de tu teléfono siguen disponibles. |
| **Ahorro de almacenamiento ilimitado** | Aplica en su lugar la identidad de un Pixel antiguo elegido. Esta opción y Calidad original ilimitada se desactivan entre sí. Fotos solo la respeta con la calidad de copia en Ahorro de almacenamiento. |

Los cambios de identidad se aplican al iniciar Google Fotos. Tras un cambio, PPE ofrece **Reiniciar ahora**, que cierra y vuelve a abrir Fotos con un toque. No se ofrece mientras se recupera almacenamiento.

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| Ajuste | Qué hace |
|---|---|
| **Video Boost** | Detecta las grabaciones con Video Boost y las sube con la identidad real del teléfono, para que Google pueda procesarlas mientras las demás copias mantienen la identidad de copia. Solo en teléfonos que graban con Video Boost: Pixel 8 Pro y la serie Pixel 9–11 Pro, incluidos los modelos XL y Fold. |
| **Recuperar almacenamiento de Video Boost** | Busca vídeos mejorados que usan almacenamiento, selecciónalos y recupera el espacio: PPE descarga cada uno, elimina la copia de la nube (también de la papelera) y lo vuelve a subir con tu ajuste de copia de seguridad. Los vídeos resubidos pierden las etiquetas y enlaces de Video Boost. |

Los vídeos procesados con Video Boost cuentan para el almacenamiento de tu cuenta de Google, aunque
esté activada una opción de copia ilimitada. Consulta [Video Boost](docs/VIDEO_BOOST.md) (en inglés)
para ver cómo se reconoce y enruta una subida.

La versión de desarrollo local es **1.1.0 / 36**. La [página de recuperación](docs/VIDEO_BOOST_RECLAIM.md)
(en inglés) pide confirmación y luego trabaja vídeo a vídeo: descargar → comprobar → eliminar la copia
de la nube → vaciarla de la papelera → volver a subir → comprobar el almacenamiento. Una tarjeta de
progreso muestra el vídeo y el paso actuales, y un historial guarda los resultados anteriores. Se
guarda una copia segura en el teléfono hasta terminar cada vídeo, y un proceso interrumpido se puede
reanudar. La búsqueda usa la caché de Fotos, así que no puede garantizar que cubra toda la biblioteca.
Consulta el [informe de recuperación](report/reclaim-7.98-1.3.2.md) (en inglés).

</details>

---

## Compatibilidad

| Android | Google Fotos | Dispositivo | Estado |
|---|---|---|---|
| 17 (API 37) | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0: DexKit encuentra todas las clases, la prueba de copia pasa, recuperación verificada con un vídeo de prueba (1.3.2) |
| 17 QPR1 (CP3A.261005.005) | 7.97.0.1000520730 | Pixel 8 Pro | Reglas de DexKit validadas con el DEX de esta versión; última prueba en el dispositivo con 1.2.2-dev |

- **Condición de activación.** Al iniciar, el módulo comprueba Android API 37, ARM64 y que DexKit haya
  resuelto todas las clases que necesita. Si no, no instala nada que cambie el comportamiento.
- **Hooks por función.** Los hooks de copia de seguridad y de Video Boost se buscan y comprueban por
  separado. Si falta uno, su fila en el diagnóstico dice *No compatible con Google Fotos …* y el otro
  sigue funcionando.
- **Compatibilidad y diagnóstico** muestra la versión del módulo, Android, el dispositivo, la versión de
  Google Fotos, la API de libxposed y el framework, y cada función como compatible, desactivada o no
  disponible. **Registro de diagnóstico** añade detalle a `adb logcat -s PixelPhotosEvolved`. Los
  registros siguen en inglés.

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Módulo y sistema</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>Compatibilidad de funciones</sub></td>
</tr>
</table>

---

## Requisitos

- Android 17 (API 37), ARM64. El APK se instala desde Android 13, pero los hooks solo se activan en Android 17
- Un framework Xposed con **libxposed API 102** (probado con Vector 2.2)
- Google Fotos 7.98.0.1007591100 (probado); otras versiones funcionan si las reglas de DexKit resuelven todas las clases necesarias (Compatibilidad y diagnóstico muestra el resultado)

## Instalación

1. Instala el APK desde la [última versión](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest)
   o el [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved).
2. Activa **Pixel Photos Evolved** en tu gestor de Xposed, con el ámbito **Google Fotos**
   (`com.google.android.apps.photos`).
3. Fuerza la detención de Google Fotos y vuelve a abrirlo.
4. Foto de perfil → **Pixel Photos Evolved**.

Para desactivarlo, desactiva el módulo en tu gestor de Xposed y reinicia Google Fotos. Más información
en [instalación y solución de problemas](docs/INSTALLATION_AND_TROUBLESHOOTING.md) (en inglés).

Los APK de las versiones se compilan aquí y el [flujo de publicación](.github/workflows/release.yml) los
vuelve a firmar con la clave de publicación y los replica en el Xposed Modules Repository.
[module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk) es la misma compilación
firmada con la clave de prueba pública de XAX, para reproducirla.

## Cómo funciona

| Pieza | Dónde | Qué hace |
|---|---|---|
| Módulo | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | Almacén XAX canónico: ciclo de vida, hooks, interfaz de ajustes y diagnóstico, compilado a DEX por el destino android-libxposed de XAX |
| Política | [policy/](policy/) | Política en Brainfuck compilada por BBC en un ejecutable stdio ARM64, empaquetado como `lib/arm64-v8a/libppepolicy.so` ([ABI](policy/ABI.md)). No es una biblioteca JNI |
| Dependencia DexKit | [module/deps/](module/deps/) y `module/libdexkit.so` | DEX de la dependencia precompilado y JNI ARM64 que encuentran en tiempo de ejecución las clases ofuscadas de Fotos; [avisos](docs/THIRD_PARTY.md) |
| Recursos | [module/res/](module/res/) | Nombre, descripción, icono adaptable y el texto de la interfaz en diez idiomas (`values*/`) |

## Traducciones

El texto de la interfaz está en recursos de cadena estándar de Android: el inglés en
`module/res/values/ui_strings.xml` y un `module/res/values-*/strings.xml` por idioma. Para corregir una
traducción, edita la cadena con el mismo `name` en el archivo de ese idioma. Para añadir un idioma, crea
una carpeta `values-<locale>` con todas las claves `ppe_*`. Las claves que falten se muestran en inglés.

## Compilación

En este repositorio solo Brainfuck y XAX canónico son código fuente. La compilación usa el SDK de XAX
fijado en [toolchain.lock.json](toolchain.lock.json); las herramientas de compilación convencionales
quedan fuera del repositorio. [Reproducir una compilación](docs/REPRODUCE.md) (en inglés) describe los
pasos exactos: verificar los almacenes, compilar el ejecutable de la política y el APK del módulo con
XAX, añadir los recursos con aapt2 y firmar. [SHA256SUMS](SHA256SUMS) enumera todos los archivos.

## Pruebas

El [estado](report/STATUS.md) separa lo comprobado en el dispositivo, lo comprobado sin conexión y lo no
probado. El [índice de pruebas](docs/EVIDENCE.md) enlaza todos los informes (en inglés).

## Créditos

- [XAX](https://github.com/MrxSiN/XAX) — lenguaje, almacén semántico y destino Android
- [BBC](https://github.com/MrxSiN/BBC) — compilador de Brainfuck
- [DexKit](https://github.com/LuckyPray/DexKit) — búsqueda de DEX en tiempo de ejecución ([avisos de dependencias](docs/THIRD_PARTY.md))
- [libxposed](https://github.com/libxposed/api) y Vector

Consulta la [atribución](docs/ATTRIBUTION.md). Pixel Photos Evolved no está afiliado a Google ni
respaldado por Google. Google Fotos y Pixel son marcas comerciales de Google LLC.
