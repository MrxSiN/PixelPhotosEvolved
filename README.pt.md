<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**Backup ilimitado em qualidade original, com Video Boost**

Google Fotos → sua foto do perfil → **Pixel Photos Evolved**.

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [Español](README.es.md) · **Português** · [Русский](README.ru.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Bahasa Indonesia](README.id.md) · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#compatibilidade)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#build)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **Testado com o Google Fotos 7.98.0.1007591100 (`52591217`) no Android 17 (API 37), Pixel 8 Pro,
> Vector 2.2 / libxposed API 102.** O PPE encontra com o DexKit cada classe do Fotos que intercepta,
> então a maioria das atualizações do Fotos não exige um novo build do módulo. Se uma classe não for
> encontrada, o Fotos mantém o próprio comportamento e **Compatibilidade e diagnóstico** mostra o que
> está indisponível. Veja o [relatório do DexKit](report/dexkit-1.4.1.md) (em inglês).

> [!IMPORTANT]
> O Google decide nos servidores dele o que pode ter backup e como o armazenamento é contado. Este
> módulo muda o que o Google Fotos informa neste smartphone. Ele não garante armazenamento ilimitado,
> e usá-lo pode violar os termos de serviço do Google. Confira o armazenamento da sua conta depois de
> ativar qualquer opção de backup.

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>Um card próprio no menu do perfil</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>No estilo das configurações do Google Fotos</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Compatibilidade e diagnóstico</sub></td>
</tr>
</table>

## Por que funciona assim

A maioria dos módulos entrega um segundo app de configurações. Este não: não tem ícone no launcher nem
activity de configurações. A página abre a partir de um card próprio no menu do perfil do Google Fotos,
acima de **Seus dados no Google Fotos** e separado dele. Usa as fontes, cores, chaves e animações do
Fotos e guarda as configurações no diretório de dados do próprio Fotos.

|  | |
|---|---|
| 🧭 **Onde você já está** | Foto do perfil → Pixel Photos Evolved. Voltar retorna ao menu. |
| 🎨 **Com a cara do Fotos** | A escala tipográfica do Fotos, as cores dos cards, a chave Material e a curva enfatizada nas transições. Os temas claro e escuro seguem o Fotos. |
| 🌐 **Fala o seu idioma** | English, 简体中文, 繁體中文, Español, Português, Русский, 日本語, 한국어, Bahasa Indonesia e Bahasa Melayu. Segue o idioma do smartphone ou o idioma do app definido para o Google Fotos. |
| 🛡 **Conhece o Fotos em que roda** | Cada hook é verificado com o build do Fotos em execução antes de ser instalado. Um hook ausente ou alterado desativa só o próprio recurso. |
| 🧠 **Política em Brainfuck** | As decisões de backup e do Video Boost são tomadas por um programa Brainfuck compilado (ARM64), chamado com uma ABI pequena e fixa. |
| 🎞 **Bytes originais do vídeo** | A recuperação mantém uma cópia segura, exclui só o vídeo escolhido na nuvem e a cópia dele na lixeira, e envia os mesmos bytes de novo sem recodificar. |
| 🔒 **Escopo limitado** | Apenas `com.google.android.apps.photos`. Sem hooks no sistema todo; o módulo não precisa de root. |

---

## Recursos

<details open>
<summary><b>☁️ Backup</b></summary>
<br>

| Configuração | O que faz |
|---|---|
| **Qualidade original ilimitada** | Aplica a identidade de um Pixel XL (2016) dentro do Google Fotos, para que o Fotos ofereça as condições de backup do Pixel XL. Os recursos de edição do seu smartphone continuam disponíveis. |
| **Economia de armazenamento ilimitada** | Aplica em vez disso a identidade de um Pixel antigo escolhido. Ela e a Qualidade original ilimitada se desativam mutuamente. O Fotos só a aceita com a qualidade de backup em Economia de armazenamento. |

As mudanças de identidade valem quando o Google Fotos inicia. Depois de uma mudança, o PPE oferece **Reiniciar agora**, que fecha e abre o Fotos de novo com um toque. A opção não aparece durante uma recuperação.

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| Configuração | O que faz |
|---|---|
| **Video Boost** | Detecta gravações do Video Boost e as envia com a identidade real do smartphone, para que o Google possa processá-las enquanto os outros backups mantêm a identidade de backup. Só em smartphones que gravam com Video Boost: Pixel 8 Pro e a série Pixel 9–11 Pro, incluindo os modelos XL e Fold. |
| **Recuperar armazenamento do Video Boost** | Procure vídeos aprimorados que usam armazenamento, selecione-os e recupere: o PPE baixa cada um, exclui a cópia na nuvem (também da lixeira) e envia de novo com sua configuração de backup. Os vídeos reenviados perdem as marcações e links do Video Boost. |

Os vídeos processados com o Video Boost contam no armazenamento da sua Conta do Google, mesmo com uma
opção de backup ilimitado ativada. Veja [Video Boost](docs/VIDEO_BOOST.md) (em inglês) para saber como
um envio é reconhecido e encaminhado.

O build de desenvolvimento local é **1.1.1 / 37**. A [página de recuperação](docs/VIDEO_BOOST_RECLAIM.md)
(em inglês) pede confirmação e depois trabalha um vídeo por vez: baixar → verificar → excluir a cópia na
nuvem → limpar da lixeira → enviar de novo → verificar o armazenamento. Um card de progresso mostra o
vídeo e a etapa atuais, e um histórico guarda os resultados anteriores. Uma cópia segura fica no
smartphone até cada vídeo terminar, e uma execução interrompida pode ser retomada. A verificação usa o
cache do Fotos, então não garante cobrir a biblioteca inteira. Veja o
[relatório de recuperação](report/reclaim-7.98-1.3.2.md) (em inglês).

</details>

---

## Compatibilidade

| Android | Google Fotos | Dispositivo | Status |
|---|---|---|---|
| 17 (API 37) | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0: todas as classes encontradas pelo DexKit, teste de backup aprovado, recuperação verificada num vídeo de teste (1.3.2) |
| 17 QPR1 (CP3A.261005.005) | 7.97.0.1000520730 | Pixel 8 Pro | Regras do DexKit validadas com o DEX deste build; último teste no dispositivo com 1.2.2-dev |

- **Condição de ativação.** Ao iniciar, o módulo verifica o Android API 37, ARM64 e se o DexKit resolveu
  todas as classes necessárias. Caso contrário, não instala nada que mude o comportamento.
- **Hooks por recurso.** Os hooks de backup e do Video Boost são encontrados e verificados separadamente.
  Se faltar um, a linha dele no diagnóstico diz *Incompatível com o Google Fotos …* e o outro continua
  funcionando.
- **Compatibilidade e diagnóstico** mostra a versão do módulo, o Android, o dispositivo, a versão do Google
  Fotos, a API libxposed e o framework, e cada recurso como compatível, desativado ou indisponível.
  **Registro de diagnóstico** adiciona detalhes a `adb logcat -s PixelPhotosEvolved`. Os registros
  continuam em inglês.

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Módulo e sistema</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>Compatibilidade dos recursos</sub></td>
</tr>
</table>

---

## Requisitos

- Android 17 (API 37), ARM64. O APK instala a partir do Android 13, mas os hooks só são ativados no Android 17
- Um framework Xposed com **libxposed API 102** (testado com Vector 2.2)
- Google Fotos 7.98.0.1007591100 (testado); outros builds funcionam quando as regras do DexKit resolvem todas as classes necessárias (Compatibilidade e diagnóstico mostra o resultado)

## Instalação

1. Instale o APK pela [versão mais recente](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest)
   ou pelo [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved).
2. Ative o **Pixel Photos Evolved** no seu gerenciador Xposed, com o escopo **Google Fotos**
   (`com.google.android.apps.photos`).
3. Force a parada do Google Fotos e abra-o de novo.
4. Foto do perfil → **Pixel Photos Evolved**.

Para desligar, desative o módulo no gerenciador Xposed e reinicie o Google Fotos. Mais em
[instalação e solução de problemas](docs/INSTALLATION_AND_TROUBLESHOOTING.md) (em inglês).

Os APKs das versões são gerados aqui e assinados de novo com a chave de lançamento pelo
[fluxo de lançamento](.github/workflows/release.yml), que também espelha cada versão no Xposed Modules
Repository. [module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk) é o mesmo
build assinado com a chave de teste pública do XAX, para reprodução.

## Como funciona

| Parte | Onde | O que faz |
|---|---|---|
| Módulo | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | Store XAX canônico: ciclo de vida, hooks, interface de configurações e diagnóstico, compilado para DEX pelo alvo android-libxposed do XAX |
| Política | [policy/](policy/) | Política em Brainfuck compilada pelo BBC num executável stdio ARM64, empacotado como `lib/arm64-v8a/libppepolicy.so` ([ABI](policy/ABI.md)). Não é uma biblioteca JNI |
| Dependência DexKit | [module/deps/](module/deps/) e `module/libdexkit.so` | DEX da dependência pré-compilado e JNI ARM64 que encontram em tempo de execução as classes ofuscadas do Fotos; [avisos](docs/THIRD_PARTY.md) |
| Recursos | [module/res/](module/res/) | Nome, descrição, ícone adaptativo e o texto da interface em dez idiomas (`values*/`) |

## Traduções

O texto da interface fica em recursos de string padrão do Android: o inglês em
`module/res/values/ui_strings.xml` e um `module/res/values-*/strings.xml` por idioma. Para corrigir uma
tradução, edite a string com o mesmo `name` no arquivo daquele idioma. Para adicionar um idioma, crie
uma pasta `values-<locale>` com todas as chaves `ppe_*`. Chaves ausentes aparecem em inglês.

## Build

Neste repositório, apenas Brainfuck e XAX canônico são código-fonte. O build usa o SDK do XAX fixado em
[toolchain.lock.json](toolchain.lock.json); as ferramentas de build convencionais ficam fora do
repositório. [Reproduzir um build](docs/REPRODUCE.md) (em inglês) descreve os passos exatos: verificar os
stores, gerar o executável da política e o APK do módulo com o XAX, adicionar os recursos com o aapt2 e
assinar. [SHA256SUMS](SHA256SUMS) lista todos os arquivos mantidos.

## Evidências

O [status](report/STATUS.md) separa o que foi verificado no dispositivo, o que foi verificado off-line e
o que não foi testado. O [índice de evidências](docs/EVIDENCE.md) liga todos os relatórios (em inglês).

## Créditos

- [XAX](https://github.com/MrxSiN/XAX) — linguagem, store semântico e alvo Android
- [BBC](https://github.com/MrxSiN/BBC) — compilador de Brainfuck
- [DexKit](https://github.com/LuckyPray/DexKit) — busca de DEX em tempo de execução ([avisos de dependências](docs/THIRD_PARTY.md))
- [libxposed](https://github.com/libxposed/api) e Vector

Veja a [atribuição](docs/ATTRIBUTION.md). O Pixel Photos Evolved não é afiliado nem endossado pelo
Google. Google Fotos e Pixel são marcas registradas da Google LLC.
