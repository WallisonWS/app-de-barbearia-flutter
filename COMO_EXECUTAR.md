# 🚀 Como Executar o BarberApp

Este guia mostra como executar o aplicativo no seu computador **sem nenhum custo** e visualizar todas as funcionalidades.

## 📋 Pré-requisitos

Você precisa ter instalado:

1. **Flutter SDK** (versão 3.24.5 ou superior)
2. **Android Studio** (para emulador Android) OU **Xcode** (para iOS, apenas macOS)
3. **Git**

## 🔧 Instalação do Flutter

### Windows

1. Baixe o Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. Extraia o arquivo ZIP em `C:\src\flutter`
3. Adicione `C:\src\flutter\bin` ao PATH do sistema
4. Abra o terminal e execute: `flutter doctor`

### macOS

```bash
# Instalar via Homebrew
brew install --cask flutter

# Ou baixar manualmente
# https://docs.flutter.dev/get-started/install/macos

# Verificar instalação
flutter doctor
```

### Linux

```bash
# Baixar Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz

# Extrair
tar xf flutter_linux_3.24.5-stable.tar.xz

# Adicionar ao PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verificar instalação
flutter doctor
```

## 📱 Configurar Emulador

### Android (Recomendado para teste)

1. Instale o Android Studio: https://developer.android.com/studio
2. Abra o Android Studio
3. Vá em **Tools** > **AVD Manager**
4. Clique em **Create Virtual Device**
5. Escolha um dispositivo (ex: Pixel 6)
6. Escolha uma imagem do sistema (ex: Android 13)
7. Clique em **Finish**

### iOS (apenas macOS)

```bash
# Instalar Xcode da App Store
# Depois executar:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

## 🎯 Executar o Aplicativo

### 1. Clone o Repositório

```bash
git clone https://github.com/WallisonWS/app-de-barbearia-flutter.git
cd app-de-barbearia-flutter
```

### 2. Instale as Dependências

```bash
flutter pub get
```

### 3. Inicie o Emulador

**Android:**
```bash
# Listar emuladores disponíveis
flutter emulators

# Iniciar emulador
flutter emulators --launch <emulator_id>

# Ou abrir pelo Android Studio: AVD Manager > Play
```

**iOS (macOS):**
```bash
open -a Simulator
```

### 4. Execute o App

```bash
# Executar no emulador conectado
flutter run

# Ou especificar dispositivo
flutter run -d <device_id>

# Ver dispositivos disponíveis
flutter devices
```

### 5. Hot Reload

Enquanto o app está rodando:
- Pressione `r` para hot reload (recarregar mudanças)
- Pressione `R` para hot restart (reiniciar app)
- Pressione `q` para sair

## 🎨 Visualizar o App

### Credenciais de Demonstração

O app vem com usuários pré-cadastrados para teste:

#### Barbeiro
```
E-mail: joao@barbearia.com
Senha: barber123
```

#### Cliente
```
E-mail: carlos@email.com
Senha: client123
```

#### Administrador (futuro)
```
E-mail: admin@barbearia.com
Senha: admin123
```

### Fluxo de Teste

1. **Splash Screen** - Animação de entrada
2. **Seleção de Perfil** - Escolha Barbeiro ou Cliente
3. **Login** - Use as credenciais acima
4. **Dashboard** - Visualize a tela principal

#### Como Barbeiro:
- Ver estatísticas (agendamentos, clientes, avaliação)
- Acessar ações rápidas (Agenda, Clientes, Serviços, Promoções)
- Ver próximos agendamentos

#### Como Cliente:
- Buscar barbeiros
- Ver serviços disponíveis
- Ver barbeiros em destaque
- Ver seus agendamentos

## 🐛 Solução de Problemas

### Erro: "No devices found"

```bash
# Verificar dispositivos
flutter devices

# Se nenhum aparecer, inicie o emulador manualmente
```

### Erro: "Gradle build failed"

```bash
# Limpar build
flutter clean
flutter pub get
flutter run
```

### Erro: "CocoaPods not installed" (iOS)

```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

### Erro: "Unable to locate Android SDK"

1. Abra Android Studio
2. Vá em **File** > **Settings** > **Appearance & Behavior** > **System Settings** > **Android SDK**
3. Anote o caminho do SDK
4. Configure a variável de ambiente `ANDROID_HOME`

### App muito lento no emulador

1. Certifique-se de que a virtualização está habilitada no BIOS
2. Use um emulador com menos recursos (Android 11 em vez de 13)
3. Ou teste em um dispositivo físico

## 📱 Executar em Dispositivo Físico

### Android

1. Ative as **Opções de desenvolvedor** no celular:
   - Vá em **Configurações** > **Sobre o telefone**
   - Toque 7 vezes em **Número da versão**
2. Ative a **Depuração USB**
3. Conecte o celular ao computador via USB
4. Execute: `flutter run`

### iOS (macOS)

1. Conecte o iPhone ao Mac
2. Abra o Xcode
3. Vá em **Window** > **Devices and Simulators**
4. Confie no dispositivo
5. Execute: `flutter run`

## 🎯 Próximos Passos

Após executar o app, você pode:

1. **Testar todas as telas** - Navegue pelo app
2. **Criar novos usuários** - Use a tela de cadastro
3. **Ver o código** - Explore a estrutura do projeto
4. **Modificar cores** - Edite `lib/core/constants/app_colors.dart`
5. **Adicionar funcionalidades** - Siga o guia em `PROXIMOS_PASSOS.md`

## 💡 Dicas

### Desenvolvimento Rápido

```bash
# Executar em modo debug (padrão)
flutter run

# Executar em modo release (mais rápido)
flutter run --release

# Ver logs detalhados
flutter run -v
```

### Inspecionar UI

Enquanto o app está rodando:
- Pressione `p` para exibir a grade de pixels
- Pressione `i` para inspecionar widgets
- Pressione `o` para alternar entre Android e iOS

### Ver Performance

```bash
# Abrir DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

## 📹 Gravar Tela (Demonstração)

### Android

```bash
# Gravar tela do emulador
adb shell screenrecord /sdcard/demo.mp4

# Parar gravação (Ctrl+C)

# Baixar vídeo
adb pull /sdcard/demo.mp4
```

### iOS

1. Abra o QuickTime Player
2. **Arquivo** > **Nova Gravação de Tela**
3. Selecione o Simulator
4. Clique em gravar

## 🆘 Suporte

Se encontrar problemas:

1. Execute `flutter doctor` e resolva os problemas indicados
2. Limpe o projeto: `flutter clean && flutter pub get`
3. Consulte a documentação: https://docs.flutter.dev/
4. Abra uma issue no GitHub

## ✅ Checklist de Execução

- [ ] Flutter instalado e `flutter doctor` sem erros críticos
- [ ] Emulador Android ou iOS configurado
- [ ] Repositório clonado
- [ ] Dependências instaladas (`flutter pub get`)
- [ ] Emulador iniciado
- [ ] App executado com sucesso (`flutter run`)
- [ ] Login realizado com credenciais de demonstração
- [ ] Dashboard visualizado

---

**Pronto! Agora você pode visualizar e testar o BarberApp sem nenhum custo! 🎉**
