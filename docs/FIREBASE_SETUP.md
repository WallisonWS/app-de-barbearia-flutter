# 🔥 Guia de Configuração do Firebase

Este guia detalha como configurar o Firebase no projeto para ter autenticação, banco de dados e storage funcionando.

---

## 📋 Pré-requisitos

- Conta Google
- Flutter instalado
- Firebase CLI instalado
- Projeto Flutter funcionando

---

## 🚀 Passo 1: Criar Projeto no Firebase Console

### 1.1 Acessar Firebase Console

1. Acesse: https://console.firebase.google.com
2. Clique em "Adicionar projeto" ou "Create a project"

### 1.2 Configurar Projeto

1. **Nome do projeto:** `app-barbearia` (ou nome de sua preferência)
2. **Google Analytics:** Ative (recomendado)
3. **Conta do Analytics:** Selecione ou crie uma nova
4. Clique em "Criar projeto"
5. Aguarde a criação (1-2 minutos)

---

## 📱 Passo 2: Adicionar App Android

### 2.1 Registrar App

1. No console, clique no ícone do Android
2. **Nome do pacote Android:** `com.seudominio.appbarbearia`
   - Encontre em: `android/app/build.gradle` → `applicationId`
3. **Apelido do app:** App Barbearia Android
4. **SHA-1:** (Opcional agora, obrigatório para Google Sign In)
   - Gerar: `cd android && ./gradlew signingReport`
   - Copie o SHA-1 do `debug` keystore
5. Clique em "Registrar app"

### 2.2 Baixar google-services.json

1. Baixe o arquivo `google-services.json`
2. Coloque em: `android/app/google-services.json`

### 2.3 Configurar build.gradle

**Arquivo:** `android/build.gradle`

```gradle
buildscript {
    dependencies {
        // Adicione esta linha
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**Arquivo:** `android/app/build.gradle`

```gradle
// No final do arquivo, adicione:
apply plugin: 'com.google.gms.google-services'
```

---

## 🍎 Passo 3: Adicionar App iOS

### 3.1 Registrar App

1. No console, clique no ícone do iOS
2. **ID do pacote iOS:** `com.seudominio.appbarbearia`
   - Encontre em: `ios/Runner.xcodeproj/project.pbxproj` → `PRODUCT_BUNDLE_IDENTIFIER`
3. **Apelido do app:** App Barbearia iOS
4. Clique em "Registrar app"

### 3.2 Baixar GoogleService-Info.plist

1. Baixe o arquivo `GoogleService-Info.plist`
2. Abra o Xcode: `open ios/Runner.xcworkspace`
3. Arraste o arquivo para `Runner/Runner` no Xcode
4. Marque "Copy items if needed"
5. Selecione target "Runner"

### 3.3 Configurar Podfile

**Arquivo:** `ios/Podfile`

Certifique-se de ter:

```ruby
platform :ios, '13.0'
```

---

## 🔐 Passo 4: Ativar Authentication

### 4.1 Acessar Authentication

1. No console Firebase, vá em "Authentication"
2. Clique em "Começar" ou "Get started"

### 4.2 Ativar Provedores

#### Email/Senha

1. Clique na aba "Sign-in method"
2. Clique em "Email/Password"
3. Ative "Email/Password"
4. Ative "Email link (passwordless sign-in)" (opcional)
5. Salve

#### Google Sign In

1. Clique em "Google"
2. Ative o provedor
3. **Email de suporte:** seu-email@gmail.com
4. Salve

**Importante para Android:**
- Adicione o SHA-1 nas configurações do projeto
- Baixe o `google-services.json` atualizado

**Importante para iOS:**
- Configure URL Schemes no Xcode
- Adicione `REVERSED_CLIENT_ID` do GoogleService-Info.plist

---

## 🗄️ Passo 5: Configurar Firestore Database

### 5.1 Criar Database

1. No console, vá em "Firestore Database"
2. Clique em "Criar banco de dados"
3. **Modo:** Teste (development) ou Produção
   - **Teste:** Acesso livre por 30 dias (para desenvolvimento)
   - **Produção:** Requer regras de segurança
4. **Localização:** southamerica-east1 (São Paulo)
5. Clique em "Ativar"

### 5.2 Configurar Regras de Segurança (Produção)

**Arquivo:** Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Função helper para verificar autenticação
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Função helper para verificar se é o próprio usuário
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Função helper para verificar se é admin
    function isAdmin() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Usuários
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Barbearias
    match /barbershops/{barbershopId} {
      allow read: if true; // Todos podem ver
      allow create: if isSignedIn();
      allow update: if isOwner(resource.data.ownerId) || isAdmin();
      allow delete: if isAdmin();
      
      // Serviços da barbearia
      match /services/{serviceId} {
        allow read: if true;
        allow write: if isOwner(get(/databases/$(database)/documents/barbershops/$(barbershopId)).data.ownerId) || isAdmin();
      }
      
      // Galeria da barbearia
      match /gallery/{imageId} {
        allow read: if true;
        allow write: if isOwner(get(/databases/$(database)/documents/barbershops/$(barbershopId)).data.ownerId) || isAdmin();
      }
    }
    
    // Agendamentos
    match /appointments/{appointmentId} {
      allow read: if isSignedIn() && 
                     (isOwner(resource.data.clientId) || 
                      isOwner(resource.data.barberId) ||
                      isAdmin());
      allow create: if isSignedIn();
      allow update: if isSignedIn() && 
                       (isOwner(resource.data.clientId) || 
                        isOwner(resource.data.barberId) ||
                        isAdmin());
      allow delete: if isAdmin();
    }
    
    // Avaliações
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if isSignedIn();
      allow update: if isOwner(resource.data.clientId) || isAdmin();
      allow delete: if isOwner(resource.data.clientId) || isAdmin();
    }
    
    // Promoções
    match /promotions/{promotionId} {
      allow read: if true;
      allow create: if isSignedIn();
      allow update: if isOwner(resource.data.barbershopId) || isAdmin();
      allow delete: if isOwner(resource.data.barbershopId) || isAdmin();
    }
  }
}
```

---

## 📦 Passo 6: Configurar Storage

### 6.1 Criar Storage

1. No console, vá em "Storage"
2. Clique em "Começar"
3. **Modo:** Teste ou Produção
4. **Localização:** southamerica-east1 (São Paulo)
5. Clique em "Concluído"

### 6.2 Configurar Regras de Segurança

**Arquivo:** Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Função helper para verificar autenticação
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Função helper para verificar tamanho (5MB máximo)
    function isValidSize() {
      return request.resource.size < 5 * 1024 * 1024;
    }
    
    // Função helper para verificar tipo de imagem
    function isImage() {
      return request.resource.contentType.matches('image/.*');
    }
    
    // Fotos de perfil de usuários
    match /users/{userId}/profile/{fileName} {
      allow read: if true;
      allow write: if isSignedIn() && 
                      request.auth.uid == userId && 
                      isValidSize() && 
                      isImage();
    }
    
    // Galeria de barbearias
    match /barbershops/{barbershopId}/gallery/{fileName} {
      allow read: if true;
      allow write: if isSignedIn() && 
                      isValidSize() && 
                      isImage();
    }
    
    // Fotos de serviços
    match /barbershops/{barbershopId}/services/{serviceId}/{fileName} {
      allow read: if true;
      allow write: if isSignedIn() && 
                      isValidSize() && 
                      isImage();
    }
  }
}
```

---

## 🔔 Passo 7: Configurar Cloud Messaging (Notificações)

### 7.1 Ativar Cloud Messaging

1. No console, vá em "Cloud Messaging"
2. Já está ativado automaticamente

### 7.2 Configurar Android

**Arquivo:** `android/app/src/main/AndroidManifest.xml`

```xml
<manifest>
    <application>
        <!-- Adicione dentro de <application> -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />
    </application>
</manifest>
```

### 7.3 Configurar iOS

1. No Xcode, vá em "Signing & Capabilities"
2. Clique em "+ Capability"
3. Adicione "Push Notifications"
4. Adicione "Background Modes"
5. Marque "Remote notifications"

---

## 🧪 Passo 8: Testar Configuração

### 8.1 Instalar Dependências

```bash
cd /home/ubuntu/app-de-barbearia-flutter
flutter pub get
```

### 8.2 Executar App

```bash
flutter run
```

### 8.3 Verificar Logs

Procure por:
```
[FIREBASE] Firebase initialized successfully
[FIREBASE] Firebase Auth initialized
[FIREBASE] Firestore initialized
```

---

## 🎯 Estrutura de Dados no Firestore

### Coleção: users

```javascript
{
  "uid": "string",
  "email": "string",
  "name": "string",
  "phone": "string",
  "photoUrl": "string",
  "role": "admin | barbershop | barber | client",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Coleção: barbershops

```javascript
{
  "id": "string",
  "name": "string",
  "description": "string",
  "ownerId": "string",
  "address": {
    "street": "string",
    "number": "string",
    "complement": "string",
    "neighborhood": "string",
    "city": "string",
    "state": "string",
    "zipCode": "string"
  },
  "contact": {
    "phone": "string",
    "email": "string",
    "whatsapp": "string"
  },
  "hours": {
    "monday": "09:00-18:00",
    "tuesday": "09:00-18:00",
    ...
  },
  "rating": "number",
  "reviewCount": "number",
  "photoUrl": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Subcoleção: barbershops/{id}/services

```javascript
{
  "id": "string",
  "name": "string",
  "description": "string",
  "price": "number",
  "duration": "number", // minutos
  "isActive": "boolean",
  "photoUrl": "string",
  "createdAt": "timestamp"
}
```

### Coleção: appointments

```javascript
{
  "id": "string",
  "barbershopId": "string",
  "barberId": "string",
  "clientId": "string",
  "serviceId": "string",
  "date": "timestamp",
  "startTime": "string", // HH:mm
  "endTime": "string", // HH:mm
  "status": "pending | confirmed | cancelled | completed",
  "price": "number",
  "notes": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Coleção: reviews

```javascript
{
  "id": "string",
  "barbershopId": "string",
  "clientId": "string",
  "clientName": "string",
  "clientPhotoUrl": "string",
  "rating": "number", // 1-5
  "comment": "string",
  "createdAt": "timestamp"
}
```

---

## ✅ Checklist de Configuração

- [ ] Projeto criado no Firebase Console
- [ ] App Android registrado
- [ ] google-services.json adicionado
- [ ] App iOS registrado
- [ ] GoogleService-Info.plist adicionado
- [ ] Authentication ativado (Email/Password)
- [ ] Authentication ativado (Google Sign In)
- [ ] SHA-1 adicionado (para Google Sign In)
- [ ] Firestore Database criado
- [ ] Regras de segurança configuradas
- [ ] Storage configurado
- [ ] Regras de Storage configuradas
- [ ] Cloud Messaging configurado
- [ ] Dependências instaladas (`flutter pub get`)
- [ ] App testado e funcionando

---

## 🆘 Problemas Comuns

### Erro: "google-services.json not found"

**Solução:** Certifique-se de que o arquivo está em `android/app/google-services.json`

### Erro: "SHA-1 certificate fingerprint"

**Solução:**
```bash
cd android
./gradlew signingReport
```
Copie o SHA-1 e adicione no Firebase Console

### Erro: "FirebaseApp is not initialized"

**Solução:** Adicione no `main.dart`:
```dart
await Firebase.initializeApp();
```

### Erro: "Permission denied" no Firestore

**Solução:** Verifique as regras de segurança no console

---

## 📚 Documentação Oficial

- Firebase Flutter: https://firebase.google.com/docs/flutter/setup
- Firebase Auth: https://firebase.google.com/docs/auth
- Firestore: https://firebase.google.com/docs/firestore
- Storage: https://firebase.google.com/docs/storage

---

**Configuração concluída! Agora você tem Firebase funcionando no projeto.** 🔥🚀
