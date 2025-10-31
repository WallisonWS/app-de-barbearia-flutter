# Guia de Configuração do Firebase

Este guia detalha todos os passos necessários para configurar o Firebase no seu projeto Flutter.

## 1. Criar Projeto no Firebase Console

Acesse o [Firebase Console](https://console.firebase.google.com/) e siga os passos:

### 1.1. Criar Novo Projeto
1. Clique em "Adicionar projeto"
2. Nome do projeto: **BarberApp** (ou nome de sua preferência)
3. Aceite os termos e clique em "Continuar"
4. Desabilite o Google Analytics (opcional para MVP)
5. Clique em "Criar projeto"

### 1.2. Adicionar App Android

1. No painel do projeto, clique no ícone do Android
2. Preencha os campos:
   - **Nome do pacote Android**: `com.barbearia.barber_app`
   - **Apelido do app**: BarberApp Android
   - **SHA-1**: (opcional por enquanto, necessário para autenticação Google)
3. Clique em "Registrar app"
4. Baixe o arquivo `google-services.json`
5. Mova o arquivo para: `android/app/google-services.json`

### 1.3. Adicionar App iOS

1. No painel do projeto, clique no ícone do iOS
2. Preencha os campos:
   - **ID do pacote iOS**: `com.barbearia.barberApp`
   - **Apelido do app**: BarberApp iOS
3. Clique em "Registrar app"
4. Baixe o arquivo `GoogleService-Info.plist`
5. Mova o arquivo para: `ios/Runner/GoogleService-Info.plist`

## 2. Configurar Firebase Authentication

### 2.1. Ativar Métodos de Autenticação

1. No Firebase Console, vá em **Authentication** > **Sign-in method**
2. Ative os seguintes provedores:
   - **E-mail/senha**: Clique em "Ativar" e salve
   - **Google** (opcional): Configure OAuth 2.0
   - **Apple** (opcional, obrigatório para iOS): Configure Sign in with Apple

### 2.2. Criar Primeiro Usuário Admin

Após implementar a autenticação no app, você precisará criar o primeiro usuário admin manualmente:

1. Crie um usuário via app ou Firebase Console
2. No Firestore, vá em **users** > selecione o documento do usuário
3. Edite o campo `role` para `"admin"`

## 3. Configurar Firestore Database

### 3.1. Criar Database

1. No Firebase Console, vá em **Firestore Database**
2. Clique em "Criar banco de dados"
3. Escolha o modo de produção
4. Selecione a localização: **southamerica-east1 (São Paulo)**
5. Clique em "Ativar"

### 3.2. Configurar Regras de Segurança

1. Vá em **Firestore Database** > **Regras**
2. Copie o conteúdo do arquivo `firestore.rules` do projeto
3. Cole no editor de regras
4. Clique em "Publicar"

### 3.3. Criar Índices

1. Vá em **Firestore Database** > **Índices**
2. Clique em "Adicionar índice"
3. Adicione os índices conforme o arquivo `firestore.indexes.json`

**Nota**: Os índices também serão criados automaticamente quando você fizer queries que os requeiram. O Firebase mostrará um link no console para criar o índice necessário.

### 3.4. Criar Coleção de Configurações Admin

Crie manualmente a primeira configuração:

1. Vá em **Firestore Database** > **Dados**
2. Clique em "Iniciar coleção"
3. ID da coleção: `admin_settings`
4. ID do documento: `config`
5. Adicione os campos:
   ```
   subscriptionPrice: 99.90 (number)
   trialPeriodDays: 7 (number)
   maintenanceMode: false (boolean)
   whatsappSupport: "+5511999999999" (string)
   ```

## 4. Configurar Firebase Storage

### 4.1. Ativar Storage

1. No Firebase Console, vá em **Storage**
2. Clique em "Começar"
3. Escolha o modo de produção
4. Selecione a localização: **southamerica-east1**
5. Clique em "Concluído"

### 4.2. Configurar Regras de Segurança

1. Vá em **Storage** > **Regras**
2. Copie o conteúdo do arquivo `storage.rules` do projeto
3. Cole no editor de regras
4. Clique em "Publicar"

## 5. Configurar Firebase Cloud Messaging (FCM)

### 5.1. Obter Chave do Servidor

1. No Firebase Console, vá em **Configurações do projeto** (ícone de engrenagem)
2. Vá na aba **Cloud Messaging**
3. Copie a **Chave do servidor** (Server Key)
4. Guarde essa chave para usar nas Cloud Functions

### 5.2. Configurar Android

Já está configurado automaticamente com o `google-services.json`.

### 5.3. Configurar iOS

1. No Xcode, abra o projeto iOS
2. Vá em **Runner** > **Signing & Capabilities**
3. Clique em "+ Capability"
4. Adicione **Push Notifications**
5. Adicione **Background Modes** e marque:
   - Remote notifications
   - Background fetch

## 6. Configurar Firebase Cloud Functions (Opcional para MVP)

### 6.1. Instalar Firebase CLI

```bash
npm install -g firebase-tools
```

### 6.2. Fazer Login

```bash
firebase login
```

### 6.3. Inicializar Functions

```bash
cd /caminho/do/projeto
firebase init functions
```

Selecione:
- Use an existing project: BarberApp
- Language: TypeScript
- ESLint: Yes
- Install dependencies: Yes

### 6.4. Criar Function para Notificações

Crie o arquivo `functions/src/index.ts`:

```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Enviar notificação quando uma nova notificação é criada
export const sendNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    const userId = notification.userId;
    
    // Buscar token FCM do usuário
    const userDoc = await admin.firestore().collection('users').doc(userId).get();
    const fcmToken = userDoc.data()?.fcmToken;
    
    if (fcmToken) {
      await admin.messaging().send({
        token: fcmToken,
        notification: {
          title: notification.title,
          body: notification.message,
        },
        data: notification.data || {},
      });
    }
  });

// Webhook Mercado Pago
export const mercadoPagoWebhook = functions.https.onRequest(async (req, res) => {
  const { type, data } = req.body;
  
  if (type === 'payment') {
    const paymentId = data.id;
    
    // TODO: Processar pagamento
    console.log('Payment received:', paymentId);
  }
  
  res.status(200).send('OK');
});

// Verificar assinaturas vencidas (executar diariamente)
export const checkExpiredSubscriptions = functions.pubsub
  .schedule('0 0 * * *') // Todos os dias à meia-noite
  .timeZone('America/Sao_Paulo')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    
    const expiredSubs = await admin.firestore()
      .collection('subscriptions')
      .where('status', '==', 'active')
      .where('nextBillingDate', '<=', now)
      .get();
    
    for (const doc of expiredSubs.docs) {
      await doc.ref.update({
        status: 'suspended',
        updatedAt: now,
      });
      
      // Atualizar status do barbeiro
      const barberId = doc.data().barberId;
      await admin.firestore().collection('barbers').doc(barberId).update({
        subscriptionStatus: 'suspended',
        updatedAt: now,
      });
    }
    
    console.log(`Suspended ${expiredSubs.size} expired subscriptions`);
  });
```

### 6.5. Deploy das Functions

```bash
firebase deploy --only functions
```

## 7. Configurar Projeto Flutter

### 7.1. Instalar FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 7.2. Configurar Firebase no Flutter

```bash
cd /caminho/do/projeto
flutterfire configure
```

Isso criará automaticamente o arquivo `lib/firebase_options.dart`.

### 7.3. Atualizar main.dart

Descomente as linhas de inicialização do Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

## 8. Testar Configuração

### 8.1. Testar no Android

```bash
flutter run -d android
```

### 8.2. Testar no iOS

```bash
flutter run -d ios
```

### 8.3. Verificar Logs

No Firebase Console, vá em **Analytics** > **DebugView** para ver eventos em tempo real.

## 9. Configurações de Produção

### 9.1. Ativar App Check (Segurança)

1. No Firebase Console, vá em **App Check**
2. Registre seus apps
3. Configure reCAPTCHA para web
4. Configure DeviceCheck para iOS
5. Configure Play Integrity para Android

### 9.2. Configurar Backup do Firestore

1. Vá em **Firestore Database** > **Importar/Exportar**
2. Configure backups automáticos para um bucket do Cloud Storage

### 9.3. Monitoramento

1. Ative **Firebase Performance Monitoring**
2. Ative **Firebase Crashlytics**
3. Configure alertas para erros críticos

## 10. Custos Estimados

### Plano Spark (Gratuito)
- Firestore: 50k leituras/dia, 20k escritas/dia
- Storage: 5GB
- Functions: 125k invocações/mês
- **Suficiente para desenvolvimento e MVP inicial**

### Plano Blaze (Pay-as-you-go)
Necessário para:
- Cloud Functions com acesso externo (Mercado Pago webhook)
- Mais de 50k leituras/dia no Firestore

**Estimativa para 100 barbeiros ativos:**
- Firestore: ~$10-20/mês
- Storage: ~$5/mês
- Functions: ~$5-10/mês
- **Total: ~$20-35/mês**

## Próximos Passos

1. ✅ Configurar Firebase Console
2. ✅ Adicionar apps Android e iOS
3. ✅ Configurar Authentication
4. ✅ Configurar Firestore
5. ✅ Configurar Storage
6. ✅ Configurar FCM
7. ⏳ Implementar autenticação no app
8. ⏳ Testar fluxo completo

## Suporte

Em caso de dúvidas, consulte:
- [Documentação Firebase](https://firebase.google.com/docs)
- [FlutterFire](https://firebase.flutter.dev/)
- [Firebase YouTube Channel](https://www.youtube.com/firebase)
