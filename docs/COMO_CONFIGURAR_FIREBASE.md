# 🔥 Como Configurar Firebase - Guia Passo a Passo

## ⚠️ IMPORTANTE: Você precisa fazer isso para o app funcionar!

Este guia vai te ensinar a configurar o Firebase em **15 minutos**.

---

## 📋 Pré-requisitos

- Conta Google (Gmail)
- Projeto Flutter clonado
- Acesso à internet

---

## 🚀 Passo 1: Criar Projeto no Firebase Console

### 1.1 Acessar Firebase Console

1. Acesse: https://console.firebase.google.com
2. Clique em **"Adicionar projeto"** ou **"Create a project"**

### 1.2 Configurar Projeto

1. **Nome do projeto:** `app-barbearia` (ou o nome que preferir)
2. Clique em **"Continuar"**
3. **Google Analytics:** Pode desabilitar por enquanto (opcional)
4. Clique em **"Criar projeto"**
5. Aguarde a criação (30-60 segundos)
6. Clique em **"Continuar"**

---

## 📱 Passo 2: Adicionar App Android

### 2.1 Registrar App

1. No console do Firebase, clique no ícone **Android** (robô verde)
2. Preencha os dados:
   - **Nome do pacote Android:** `com.seuprojeto.barbershop`
   - **Apelido do app:** `Barbershop App` (opcional)
   - **SHA-1:** Deixe em branco por enquanto
3. Clique em **"Registrar app"**

### 2.2 Baixar google-services.json

1. Clique em **"Fazer download do google-services.json"**
2. Salve o arquivo
3. **IMPORTANTE:** Copie o arquivo para:
   ```
   android/app/google-services.json
   ```
4. Clique em **"Próximo"** e depois **"Continuar no console"**

### 2.3 Verificar build.gradle

Verifique se os arquivos já têm as configurações corretas:

**android/build.gradle:**
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

**android/app/build.gradle:**
```gradle
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        applicationId "com.seuprojeto.barbershop"
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

---

## 🍎 Passo 3: Adicionar App iOS (Opcional - se for publicar na App Store)

### 3.1 Registrar App iOS

1. No console do Firebase, clique no ícone **iOS** (maçã)
2. Preencha os dados:
   - **ID do pacote iOS:** `com.seuprojeto.barbershop`
   - **Apelido do app:** `Barbershop App` (opcional)
3. Clique em **"Registrar app"**

### 3.2 Baixar GoogleService-Info.plist

1. Clique em **"Fazer download do GoogleService-Info.plist"**
2. Salve o arquivo
3. **IMPORTANTE:** Copie o arquivo para:
   ```
   ios/Runner/GoogleService-Info.plist
   ```
4. Clique em **"Próximo"** e depois **"Continuar no console"**

---

## 🔐 Passo 4: Habilitar Authentication

### 4.1 Ativar Email/Senha

1. No menu lateral, clique em **"Authentication"** (ou **"Autenticação"**)
2. Clique em **"Get started"** ou **"Começar"**
3. Na aba **"Sign-in method"**, clique em **"Email/Password"**
4. **Ative** a opção **"Email/Password"**
5. Clique em **"Salvar"**

### 4.2 Ativar Google Sign-In

1. Na mesma tela, clique em **"Google"**
2. **Ative** a opção
3. Escolha um **email de suporte** (seu Gmail)
4. Clique em **"Salvar"**

---

## 💾 Passo 5: Configurar Firestore Database

### 5.1 Criar Database

1. No menu lateral, clique em **"Firestore Database"**
2. Clique em **"Criar banco de dados"** ou **"Create database"**
3. Escolha **"Iniciar no modo de teste"** (Start in test mode)
4. Escolha a localização: **southamerica-east1 (São Paulo)** ou mais próxima
5. Clique em **"Ativar"** ou **"Enable"**

### 5.2 Configurar Regras de Segurança

1. Clique na aba **"Regras"** ou **"Rules"**
2. Substitua o conteúdo por:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Função auxiliar para verificar autenticação
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Função para verificar se é o próprio usuário
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Função para verificar se é admin
    function isAdmin() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Usuários
    match /users/{userId} {
      allow read: if isSignedIn();
      allow write: if isOwner(userId) || isAdmin();
    }
    
    // Barbearias
    match /barbershops/{barbershopId} {
      allow read: if true; // Qualquer um pode ver
      allow create: if isSignedIn();
      allow update, delete: if isAdmin() || 
                               get(/databases/$(database)/documents/barbershops/$(barbershopId)).data.ownerId == request.auth.uid;
      
      // Subcoleção de serviços
      match /services/{serviceId} {
        allow read: if true;
        allow write: if isAdmin() || 
                        get(/databases/$(database)/documents/barbershops/$(barbershopId)).data.ownerId == request.auth.uid;
      }
      
      // Subcoleção de galeria
      match /gallery/{imageId} {
        allow read: if true;
        allow write: if isAdmin() || 
                        get(/databases/$(database)/documents/barbershops/$(barbershopId)).data.ownerId == request.auth.uid;
      }
    }
    
    // Agendamentos
    match /appointments/{appointmentId} {
      allow read: if isSignedIn() && (
        isAdmin() ||
        resource.data.clientId == request.auth.uid ||
        resource.data.barberId == request.auth.uid
      );
      allow create: if isSignedIn();
      allow update: if isSignedIn() && (
        isAdmin() ||
        resource.data.barberId == request.auth.uid
      );
      allow delete: if isAdmin();
    }
  }
}
```

3. Clique em **"Publicar"** ou **"Publish"**

### 5.3 Criar Índices

1. Clique na aba **"Índices"** ou **"Indexes"**
2. Clique em **"Adicionar índice"**

**Índice 1: Agendamentos por Barbeiro e Data**
- Coleção: `appointments`
- Campos:
  - `barberId` (Crescente)
  - `dateTime` (Crescente)
- Status da consulta: Habilitado

**Índice 2: Agendamentos por Barbeiro e Status**
- Coleção: `appointments`
- Campos:
  - `barberId` (Crescente)
  - `status` (Crescente)
  - `dateTime` (Crescente)
- Status da consulta: Habilitado

3. Clique em **"Criar"** para cada índice

---

## 📦 Passo 6: Configurar Storage

### 6.1 Ativar Storage

1. No menu lateral, clique em **"Storage"**
2. Clique em **"Começar"** ou **"Get started"**
3. Clique em **"Próximo"** (mantenha as regras padrão por enquanto)
4. Escolha a localização: **southamerica-east1 (São Paulo)**
5. Clique em **"Concluído"**

### 6.2 Configurar Regras de Segurança

1. Clique na aba **"Regras"** ou **"Rules"**
2. Substitua o conteúdo por:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Função auxiliar
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Fotos de perfil de usuários
    match /users/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if isSignedIn() && request.auth.uid == userId;
    }
    
    // Fotos de barbearias
    match /barbershops/{barbershopId}/{allPaths=**} {
      allow read: if true;
      allow write: if isSignedIn();
    }
  }
}
```

3. Clique em **"Publicar"**

---

## 🔔 Passo 7: Configurar Cloud Messaging (Notificações)

### 7.1 Ativar Cloud Messaging

1. No menu lateral, clique em **"Cloud Messaging"**
2. Se aparecer opção para ativar, clique em **"Ativar"**
3. Anote o **Server Key** (vamos usar depois)

---

## ✅ Passo 8: Verificar Configuração

### 8.1 Checklist

Verifique se você fez tudo:

- [ ] Criou projeto no Firebase
- [ ] Adicionou app Android
- [ ] Baixou google-services.json
- [ ] Copiou google-services.json para android/app/
- [ ] Habilitou Email/Password no Authentication
- [ ] Habilitou Google Sign-In no Authentication
- [ ] Criou Firestore Database
- [ ] Configurou regras do Firestore
- [ ] Criou índices do Firestore
- [ ] Ativou Storage
- [ ] Configurou regras do Storage
- [ ] Ativou Cloud Messaging

### 8.2 Testar

Execute o app:

```bash
flutter clean
flutter pub get
flutter run
```

Se tudo estiver correto, o app vai:
1. Conectar ao Firebase
2. Mostrar tela de login
3. Permitir criar conta
4. Permitir fazer login

---

## 🆘 Problemas Comuns

### Erro: "google-services.json not found"

**Solução:** Certifique-se de que o arquivo está em `android/app/google-services.json`

### Erro: "FirebaseException: [core/no-app]"

**Solução:** Verifique se o Firebase foi inicializado no main.dart

### Erro: "PlatformException: sign_in_failed"

**Solução:** 
1. Adicione SHA-1 no Firebase Console
2. Baixe novo google-services.json
3. Execute `flutter clean` e `flutter run`

### Como obter SHA-1?

```bash
cd android
./gradlew signingReport
```

Copie o SHA-1 que aparece e adicione no Firebase Console:
1. Configurações do projeto (engrenagem)
2. Seus apps
3. Adicionar impressão digital

---

## 🎉 Pronto!

Seu Firebase está configurado! Agora o app vai funcionar com:
- ✅ Login e registro reais
- ✅ Banco de dados na nuvem
- ✅ Upload de imagens
- ✅ Notificações push

---

## 📞 Precisa de Ajuda?

Se tiver dúvidas:
1. Reveja este guia passo a passo
2. Consulte a documentação oficial: https://firebase.google.com/docs
3. Abra uma issue no GitHub

---

**Tempo estimado:** 15-20 minutos  
**Dificuldade:** ⭐⭐☆☆☆ (Fácil)

**Boa sorte!** 🚀
