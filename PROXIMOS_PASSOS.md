# 🚀 Próximos Passos para Desenvolvimento

Este documento detalha os próximos passos para continuar o desenvolvimento do BarberApp.

## ✅ O que já foi feito

1. **Estrutura do Projeto**
   - ✅ Projeto Flutter criado e configurado
   - ✅ Estrutura de pastas seguindo Clean Architecture
   - ✅ Dependências principais adicionadas ao pubspec.yaml
   - ✅ Repositório GitHub configurado e código commitado

2. **Arquitetura e Design**
   - ✅ Entidades de domínio criadas (User, Barber, Appointment, etc.)
   - ✅ Constantes de cores, strings e rotas definidas
   - ✅ Tema Material Design 3 configurado (light e dark)
   - ✅ Splash screen inicial implementada

3. **Backend e Banco de Dados**
   - ✅ Regras de segurança do Firestore definidas
   - ✅ Regras de segurança do Storage definidas
   - ✅ Índices do Firestore especificados
   - ✅ Estrutura do banco de dados documentada

4. **Documentação**
   - ✅ README.md completo
   - ✅ Arquitetura do sistema documentada
   - ✅ Especificações técnicas detalhadas
   - ✅ Guia de configuração do Firebase

## 🔄 Próximas Etapas (Ordem Recomendada)

### Fase 1: Configuração do Firebase (1-2 dias)

#### 1.1. Criar Projeto no Firebase Console
- [ ] Acessar https://console.firebase.google.com/
- [ ] Criar novo projeto "BarberApp"
- [ ] Adicionar app Android (package: com.barbearia.barber_app)
- [ ] Adicionar app iOS (bundle: com.barbearia.barberApp)
- [ ] Baixar e adicionar arquivos de configuração:
  - `google-services.json` → `android/app/`
  - `GoogleService-Info.plist` → `ios/Runner/`

#### 1.2. Configurar Firebase no Flutter
```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase automaticamente
flutterfire configure
```

#### 1.3. Ativar Serviços do Firebase
- [ ] Authentication: Ativar Email/Senha
- [ ] Firestore: Criar database em southamerica-east1
- [ ] Storage: Ativar storage
- [ ] Cloud Messaging: Configurar FCM

#### 1.4. Aplicar Regras de Segurança
- [ ] Copiar conteúdo de `firestore.rules` para Firebase Console
- [ ] Copiar conteúdo de `storage.rules` para Firebase Console
- [ ] Publicar regras

### Fase 2: Implementação da Autenticação (3-4 dias)

#### 2.1. Criar Datasource do Firebase Auth
```dart
// lib/data/datasources/firebase_auth_datasource.dart
class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<UserCredential> registerWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();
}
```

#### 2.2. Criar Repository de Autenticação
```dart
// lib/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;
  final FirestoreDataSource firestoreDataSource;
  
  @override
  Future<Either<Failure, User>> login(String email, String password);
  
  @override
  Future<Either<Failure, User>> register(RegisterParams params);
}
```

#### 2.3. Criar Use Cases
- [ ] `LoginUseCase`
- [ ] `RegisterUseCase`
- [ ] `LogoutUseCase`
- [ ] `GetCurrentUserUseCase`

#### 2.4. Criar Provider de Autenticação
```dart
// lib/presentation/providers/auth_provider.dart
class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  
  User? _currentUser;
  bool _isLoading = false;
  
  Future<void> login(String email, String password);
  Future<void> register(RegisterParams params);
  Future<void> logout();
}
```

#### 2.5. Criar Telas de Autenticação
- [ ] `RoleSelectionScreen` - Escolher perfil (Barbeiro/Cliente)
- [ ] `LoginScreen` - Tela de login
- [ ] `RegisterScreen` - Tela de cadastro
- [ ] `ForgotPasswordScreen` - Recuperação de senha

### Fase 3: Sistema de Navegação (1-2 dias)

#### 3.1. Configurar GoRouter
```dart
// lib/core/router/app_router.dart
final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    // Lógica de redirecionamento baseada em autenticação
  },
  routes: [
    // Definir todas as rotas
  ],
);
```

#### 3.2. Implementar Proteção de Rotas
- [ ] Verificar autenticação antes de acessar rotas protegidas
- [ ] Redirecionar para login se não autenticado
- [ ] Redirecionar para dashboard correto baseado no role

### Fase 4: Dashboard do Barbeiro (4-5 dias)

#### 4.1. Criar Tela Principal
- [ ] `BarberDashboardScreen` com estatísticas
- [ ] Cards com métricas (clientes, agendamentos, receita)
- [ ] Gráficos simples (opcional)

#### 4.2. Implementar Gestão de Clientes
- [ ] `ClientsListScreen` - Lista de clientes
- [ ] `ClientDetailsScreen` - Detalhes do cliente
- [ ] `AddClientScreen` - Adicionar novo cliente
- [ ] Botão para abrir WhatsApp

#### 4.3. Implementar Gestão de Serviços
- [ ] `ServicesManagementScreen` - Lista de serviços
- [ ] `AddServiceScreen` - Adicionar serviço
- [ ] `EditServiceScreen` - Editar serviço
- [ ] CRUD completo de serviços

### Fase 5: Sistema de Agendamentos (5-6 dias)

#### 5.1. Criar Modelo de Dados
- [ ] Implementar `AppointmentModel` com conversão Firestore
- [ ] Criar repository de agendamentos
- [ ] Criar use cases (criar, listar, cancelar, atualizar)

#### 5.2. Criar Tela de Agenda
- [ ] `ScheduleScreen` com calendário (table_calendar)
- [ ] Visualização de agendamentos por dia
- [ ] Filtros por status
- [ ] Detalhes do agendamento

#### 5.3. Criar Fluxo de Agendamento (Cliente)
- [ ] `BarberSearchScreen` - Buscar barbeiros
- [ ] `BarberProfileScreen` - Ver perfil do barbeiro
- [ ] `BookingScreen` - Agendar horário
- [ ] Seleção de serviço, data e horário
- [ ] Confirmação de agendamento

### Fase 6: Sistema de Promoções (2-3 dias)

#### 6.1. Criar CRUD de Promoções
- [ ] `PromotionsScreen` - Lista de promoções
- [ ] `CreatePromotionScreen` - Criar promoção
- [ ] Upload de imagem da promoção
- [ ] Definir desconto e validade

#### 6.2. Implementar Envio de Promoções
- [ ] Selecionar clientes para enviar
- [ ] Criar notificação no Firestore
- [ ] Trigger para enviar push notification

### Fase 7: Integração WhatsApp (1 dia)

#### 7.1. Implementar Função de Abertura
```dart
// lib/core/utils/whatsapp_helper.dart
class WhatsAppHelper {
  static Future<void> openWhatsApp(String phone, String message) async {
    final url = 'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
```

#### 7.2. Adicionar Botões nas Telas
- [ ] Botão no perfil do cliente
- [ ] Botão na lista de clientes
- [ ] Mensagem pré-formatada

### Fase 8: Notificações Push (2-3 dias)

#### 8.1. Configurar FCM no App
```dart
// lib/core/services/notification_service.dart
class NotificationService {
  Future<void> initialize();
  Future<String?> getToken();
  Future<void> saveTokenToFirestore(String token);
}
```

#### 8.2. Criar Cloud Function
```typescript
// functions/src/index.ts
export const sendNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    // Enviar notificação push
  });
```

#### 8.3. Implementar Tela de Notificações
- [ ] `NotificationsScreen` - Lista de notificações
- [ ] Marcar como lida
- [ ] Navegação ao clicar

### Fase 9: Integração Mercado Pago (4-5 dias)

#### 9.1. Configurar Credenciais
- [ ] Criar conta no Mercado Pago Developers
- [ ] Obter Access Token
- [ ] Configurar webhook

#### 9.2. Implementar Fluxo de Assinatura
```dart
// lib/data/datasources/mercadopago_datasource.dart
class MercadoPagoDataSource {
  Future<String> createSubscriptionPreference(String barberId, double amount);
  Future<PaymentInfo> getPaymentInfo(String paymentId);
}
```

#### 9.3. Criar Telas de Pagamento
- [ ] `SubscriptionScreen` - Informações da assinatura
- [ ] `PaymentScreen` - Tela de pagamento
- [ ] Integração com SDK do Mercado Pago

#### 9.4. Implementar Webhook
- [ ] Cloud Function para receber notificações
- [ ] Atualizar status de pagamento no Firestore
- [ ] Atualizar status de assinatura do barbeiro

### Fase 10: Painel Administrativo (3-4 dias)

#### 10.1. Criar Dashboard Admin
- [ ] `AdminDashboardScreen` com métricas globais
- [ ] Total de barbeiros, assinaturas ativas, receita

#### 10.2. Implementar Gestão de Barbeiros
- [ ] `ManageBarbersScreen` - Lista de barbeiros
- [ ] `BarberDetailsScreen` - Detalhes do barbeiro
- [ ] Aprovar/Suspender/Excluir barbeiro

#### 10.3. Criar Relatórios Financeiros
- [ ] `FinancialReportsScreen` - Relatórios
- [ ] Gráficos de receita
- [ ] Exportação de dados (CSV)

### Fase 11: Testes e Refinamentos (3-4 dias)

#### 11.1. Testes Unitários
- [ ] Testar use cases
- [ ] Testar repositories
- [ ] Testar models

#### 11.2. Testes de Widget
- [ ] Testar telas principais
- [ ] Testar widgets customizados

#### 11.3. Testes de Integração
- [ ] Testar fluxo de autenticação
- [ ] Testar fluxo de agendamento
- [ ] Testar fluxo de pagamento

#### 11.4. Refinamentos de UI/UX
- [ ] Ajustar cores e espaçamentos
- [ ] Adicionar animações
- [ ] Melhorar feedback visual
- [ ] Testar em diferentes tamanhos de tela

### Fase 12: Deploy (2-3 dias)

#### 12.1. Preparar para Produção
- [ ] Configurar variáveis de ambiente
- [ ] Gerar ícones e splash screens
- [ ] Configurar assinatura de apps

#### 12.2. Build Android
```bash
flutter build appbundle --release
```
- [ ] Criar conta no Google Play Console
- [ ] Preparar store listing
- [ ] Upload do AAB
- [ ] Submeter para revisão

#### 12.3. Build iOS
```bash
flutter build ipa --release
```
- [ ] Criar conta no Apple Developer
- [ ] Configurar certificados
- [ ] Preparar App Store listing
- [ ] Upload via Xcode
- [ ] Submeter para revisão

## 📊 Estimativa de Tempo Total

- **Configuração Firebase**: 1-2 dias
- **Autenticação**: 3-4 dias
- **Navegação**: 1-2 dias
- **Dashboard Barbeiro**: 4-5 dias
- **Agendamentos**: 5-6 dias
- **Promoções**: 2-3 dias
- **WhatsApp**: 1 dia
- **Notificações**: 2-3 dias
- **Mercado Pago**: 4-5 dias
- **Painel Admin**: 3-4 dias
- **Testes**: 3-4 dias
- **Deploy**: 2-3 dias

**Total Estimado: 31-42 dias de desenvolvimento** (aproximadamente 6-8 semanas)

## 🎯 Dicas Importantes

### Desenvolvimento Iterativo
1. Complete uma fase por vez
2. Teste cada funcionalidade antes de avançar
3. Faça commits frequentes com mensagens descritivas
4. Mantenha a documentação atualizada

### Boas Práticas
- Use `flutter analyze` regularmente
- Formate código com `dart format .`
- Escreva testes para funcionalidades críticas
- Documente funções públicas
- Use constantes para strings e valores mágicos

### Debug e Testes
- Use Firebase Emulator Suite para desenvolvimento local
- Teste em dispositivos reais, não apenas emuladores
- Use Firebase DebugView para monitorar eventos
- Configure Crashlytics para produção

### Performance
- Use `const` constructors quando possível
- Implemente lazy loading em listas longas
- Otimize queries do Firestore com índices
- Cache dados localmente com Hive

## 📚 Recursos Úteis

### Documentação Oficial
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Mercado Pago Developers](https://www.mercadopago.com.br/developers)

### Tutoriais e Cursos
- [Flutter & Firebase Course](https://www.youtube.com/watch?v=sfA3NWDBPZ4)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Provider State Management](https://pub.dev/packages/provider)

### Comunidades
- [Flutter Brasil no Telegram](https://t.me/flutterbr)
- [Flutter Community no Discord](https://discord.gg/flutter)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

## ✅ Checklist Rápido

Antes de começar cada fase:
- [ ] Ler documentação relacionada
- [ ] Entender o objetivo da fase
- [ ] Preparar ambiente de desenvolvimento
- [ ] Criar branch no Git (opcional)

Ao finalizar cada fase:
- [ ] Testar funcionalidade implementada
- [ ] Fazer commit das alterações
- [ ] Atualizar documentação se necessário
- [ ] Marcar fase como concluída neste documento

## 🚀 Começando Agora

Para começar o desenvolvimento imediatamente:

1. **Configure o Firebase** seguindo [CONFIGURACAO_FIREBASE.md](./CONFIGURACAO_FIREBASE.md)
2. **Instale as dependências**: `flutter pub get`
3. **Execute o app**: `flutter run`
4. **Comece pela Fase 2**: Implementação da Autenticação

Boa sorte no desenvolvimento! 💪
