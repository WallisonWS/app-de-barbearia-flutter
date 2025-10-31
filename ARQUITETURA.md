# Arquitetura do Sistema - App Barbearia

## Visão Geral

Sistema completo de agendamento de barbearia com modelo de negócio SaaS (Software as a Service), onde barbeiros pagam mensalidade para utilizar a plataforma e gerenciar seus clientes.

## Modelo de Negócio

### Stakeholders
1. **Administrador (Você)**: Controle total da plataforma, gerenciamento de barbeiros, configurações globais
2. **Barbeiros**: Assinantes mensais que utilizam a plataforma para gerenciar clientes e agendamentos
3. **Clientes**: Usuários finais que agendam serviços com os barbeiros

### Fluxo de Receita
- Cobrança mensal recorrente dos barbeiros cadastrados
- Gateway de pagamento: Mercado Pago (recomendado para Brasil)

## Arquitetura Técnica

### Stack Tecnológico

#### Frontend (Mobile)
- **Framework**: Flutter 3.x
- **Linguagem**: Dart
- **Plataformas**: Android e iOS
- **State Management**: Provider / Riverpod
- **Arquitetura**: Clean Architecture com MVVM

#### Backend
- **Plataforma**: Firebase (BaaS - Backend as a Service)
  - **Authentication**: Firebase Auth (email/senha, Google, Apple)
  - **Database**: Cloud Firestore (NoSQL)
  - **Storage**: Firebase Storage (fotos de perfil, promoções)
  - **Functions**: Cloud Functions (lógica de negócio, webhooks)
  - **Messaging**: Firebase Cloud Messaging (notificações push)

#### Integrações Externas
- **Pagamentos**: Mercado Pago API
- **WhatsApp**: URL Scheme (whatsapp://send)
- **Notificações**: Firebase Cloud Messaging

### Estrutura do Banco de Dados (Firestore)

```
/users
  /{userId}
    - name: string
    - email: string
    - phone: string
    - role: string (admin, barber, client)
    - photoUrl: string
    - createdAt: timestamp
    - updatedAt: timestamp

/barbers
  /{barberId}
    - userId: string (ref to users)
    - businessName: string
    - description: string
    - address: object
    - workingHours: map
    - services: array
    - subscriptionStatus: string (active, inactive, suspended)
    - subscriptionExpiresAt: timestamp
    - totalClients: number
    - rating: number
    - createdAt: timestamp

/clients
  /{clientId}
    - userId: string (ref to users)
    - barberId: string (ref to barbers)
    - notes: string
    - lastVisit: timestamp
    - totalVisits: number
    - createdAt: timestamp

/appointments
  /{appointmentId}
    - barberId: string
    - clientId: string
    - serviceId: string
    - scheduledAt: timestamp
    - duration: number (minutes)
    - status: string (scheduled, confirmed, completed, cancelled)
    - price: number
    - notes: string
    - createdAt: timestamp
    - updatedAt: timestamp

/services
  /{serviceId}
    - barberId: string
    - name: string
    - description: string
    - price: number
    - duration: number (minutes)
    - active: boolean
    - createdAt: timestamp

/promotions
  /{promotionId}
    - barberId: string
    - title: string
    - description: string
    - discount: number (percentage)
    - validFrom: timestamp
    - validUntil: timestamp
    - imageUrl: string
    - active: boolean
    - createdAt: timestamp

/subscriptions
  /{subscriptionId}
    - barberId: string
    - planType: string (monthly, yearly)
    - amount: number
    - status: string (active, pending, cancelled, overdue)
    - paymentMethod: string
    - mercadoPagoId: string
    - startDate: timestamp
    - nextBillingDate: timestamp
    - createdAt: timestamp
    - updatedAt: timestamp

/payments
  /{paymentId}
    - subscriptionId: string
    - barberId: string
    - amount: number
    - status: string (pending, approved, rejected)
    - paymentMethod: string
    - mercadoPagoId: string
    - paidAt: timestamp
    - createdAt: timestamp

/notifications
  /{notificationId}
    - userId: string
    - type: string (appointment, promotion, payment, system)
    - title: string
    - message: string
    - read: boolean
    - data: map
    - createdAt: timestamp

/admin_settings
  /config
    - subscriptionPrice: number
    - trialPeriodDays: number
    - maintenanceMode: boolean
    - whatsappSupport: string
```

## Funcionalidades por Perfil

### Administrador (Você)
- Dashboard completo com métricas
- Gerenciamento de barbeiros (aprovar, suspender, excluir)
- Visualização de todos os agendamentos
- Controle de pagamentos e mensalidades
- Configurações globais da plataforma
- Relatórios financeiros
- Suporte aos barbeiros

### Barbeiro
- Dashboard pessoal com métricas
- Gerenciamento de clientes
- Agenda de horários
- Cadastro de serviços e preços
- Criação e envio de promoções
- Integração WhatsApp (botão para chamar cliente)
- Histórico de atendimentos
- Gerenciamento de perfil e horários de trabalho
- Visualização de status da assinatura

### Cliente
- Busca de barbeiros próximos
- Visualização de serviços e preços
- Agendamento de horários
- Histórico de cortes
- Recebimento de promoções
- Avaliação do barbeiro
- Notificações de lembretes

## Fluxos Principais

### 1. Cadastro e Onboarding do Barbeiro
1. Barbeiro baixa o app e se cadastra
2. Escolhe plano de assinatura (trial de 7 dias grátis)
3. Preenche informações do negócio
4. Configura serviços e horários
5. Admin aprova o cadastro
6. Barbeiro pode começar a usar

### 2. Agendamento
1. Cliente busca barbeiro
2. Visualiza serviços disponíveis
3. Escolhe data e horário
4. Confirma agendamento
5. Barbeiro recebe notificação
6. Cliente recebe confirmação e lembrete

### 3. Gestão de Clientes pelo Barbeiro
1. Barbeiro visualiza lista de clientes
2. Acessa perfil do cliente
3. Vê histórico de atendimentos
4. Pode chamar no WhatsApp
5. Pode enviar promoção personalizada

### 4. Sistema de Promoções
1. Barbeiro cria promoção
2. Define desconto e validade
3. Seleciona clientes (todos ou específicos)
4. Envia notificação push
5. Cliente recebe e pode agendar com desconto

### 5. Cobrança de Mensalidade
1. Sistema verifica assinaturas próximas do vencimento
2. Envia notificação ao barbeiro
3. Gera cobrança via Mercado Pago
4. Processa pagamento
5. Atualiza status da assinatura
6. Se não pagar: suspende conta após período de graça

## Segurança

### Regras de Segurança Firestore
- Usuários só podem ler/editar seus próprios dados
- Barbeiros só podem gerenciar seus próprios clientes e agendamentos
- Admin tem acesso completo
- Validação de roles em todas as operações
- Proteção contra leitura/escrita não autorizada

### Autenticação
- Firebase Authentication
- Verificação de email obrigatória
- Tokens JWT para API calls
- Refresh tokens automáticos

## Escalabilidade

### Performance
- Paginação em listas longas
- Cache local com Hive/SharedPreferences
- Lazy loading de imagens
- Índices compostos no Firestore

### Custos Firebase (Estimativa)
- **Firestore**: ~$0.06 por 100k leituras
- **Storage**: ~$0.026 por GB
- **Functions**: ~$0.40 por milhão de invocações
- **Hosting**: Grátis até 10GB

## Roadmap de Desenvolvimento

### Fase 1 - MVP (4-6 semanas)
- ✅ Autenticação e cadastros
- ✅ Perfis de usuário (admin, barbeiro, cliente)
- ✅ Sistema de agendamentos básico
- ✅ Integração WhatsApp
- ✅ Painel administrativo básico

### Fase 2 - Core Features (3-4 semanas)
- ✅ Sistema de promoções
- ✅ Integração Mercado Pago
- ✅ Cobrança de mensalidades
- ✅ Notificações push
- ✅ Dashboard com métricas

### Fase 3 - Melhorias (2-3 semanas)
- Sistema de avaliações
- Relatórios avançados
- Busca geolocalizada
- Chat in-app
- Exportação de dados

### Fase 4 - Expansão (Futuro)
- Painel web administrativo
- Múltiplos barbeiros por estabelecimento
- Sistema de fidelidade
- Integração com redes sociais
- Analytics avançado

## Considerações Importantes

### Compliance
- LGPD: Política de privacidade e termos de uso
- Consentimento para uso de dados
- Direito ao esquecimento

### UX/UI
- Design moderno e intuitivo
- Cores: Tema escuro/claro
- Acessibilidade
- Responsividade

### Testes
- Testes unitários (Dart)
- Testes de integração
- Testes E2E com Flutter Driver
- Beta testing antes do lançamento

## Próximos Passos

1. ✅ Configurar projeto Flutter
2. ✅ Configurar Firebase
3. ✅ Implementar autenticação
4. ✅ Desenvolver telas principais
5. ✅ Integrar backend
6. ✅ Implementar pagamentos
7. ✅ Testes e deploy
