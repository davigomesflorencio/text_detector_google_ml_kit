# Changelog

Todas as mudanças notáveis deste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).

## [3.0.2] - 2026-10-12

### Adicionado

- Tela de splash (`lib/src/pages/splash/splash_page.dart`) com a logo do app em animação de pulsar (aumenta e diminui), redirecionando para a tela principal após 3 segundos
- Descrição do app acima da logo na tela inicial
- Card de resultado da detecção de texto, com:
  - Cabeçalho com botão para copiar o texto reconhecido
  - Contadores de palavras, linhas e caracteres
  - Texto reconhecido selecionável, com aviso quando nenhum texto é detectado
  - Informações do arquivo: nome, tamanho e caminho

### Alterado

- Rotas: `/` passa a abrir a splash e a tela de reconhecimento de texto foi movida para `/home`
- Layout da tela inicial centralizado vertical e horizontalmente, com largura máxima de 500px
- O resultado da detecção só é exibido após o término do processamento
- `targetSdk` elevado de 35 para 36

### Corrigido

- Reconhecimento de texto falhando no build de release ("Falha ao processar imagem"): o R8 removia os construtores dos `ComponentRegistrar` do ML Kit. Adicionadas regras de keep em `android/app/proguard-rules.pro`, que agora é referenciado no `build.gradle.kts`
- Após um erro no processamento, novas imagens eram ignoradas porque o estado de "ocupado" não era liberado

### Versão

- `pubspec.yaml`: `3.0.0+12` → `3.0.2+14`
- Android `versionCode`/`versionName`: `12` / `3.0.0` → `14` / `3.0.2`

## [3.0.0] - 2026-09-09

### Alterado

- Dependências Flutter atualizadas para as versões mais recentes compatíveis:
  - `google_mlkit_text_recognition`: ^0.15.0 → ^0.17.1
  - `google_mlkit_commons`: ^0.11.0 → ^0.13.0
  - `camera`: ^0.11.1 → ^0.12.1
  - `package_info_plus`: ^8.3.0 → ^10.2.1
  - `flutter_lints`: ^5.0.0 → ^6.0.0
  - Demais dependências transitivas atualizadas no `pubspec.lock`
- Build Android migrado para **Android Gradle Plugin 9.0.1** e **Gradle 9.1.0** (antes: AGP 8.7.0 / Gradle 8.10.2)
  - Kotlin Gradle Plugin atualizado para 2.2.20
  - `compileSdk` elevado de 35 para 36 (exigido pelas versões atualizadas dos plugins)
  - `targetSdk` elevado de 35 para 36, atendendo à exigência da Play Store para uso das APIs mais recentes do Android (otimizações de segurança e desempenho)
  - NDK atualizado de 27.0.12077973 para 28.2.13676358
  - Mantidos os opt-outs `android.newDsl=false` e `android.builtInKotlin=false` em `android/gradle.properties`, já que parte do ecossistema de plugins de terceiros ainda está se adaptando à nova DSL do AGP 9
- Workflow de CI/CD (`.github/workflows/dart.yml`) atualizado:
  - Adicionado setup explícito do JDK 21 (Temurin)
  - Canal do Flutter alterado de versão fixa (3.29.2) para `stable`
  - Adicionada aceitação automática das licenças do Android SDK
  - Nome do release ajustado para refletir a série de versão 3.0

### Versão

- `pubspec.yaml`: `2.6.2+1` → `3.0.0+12`
- Android `versionCode`/`versionName`: `11` / `2.6.2` → `12` / `3.0.0`
