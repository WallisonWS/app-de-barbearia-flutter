# 💈 BarberApp - Sistema Completo de Gestão de Barbearia

Aplicativo mobile completo desenvolvido em Flutter para gerenciamento de barbearias com sistema de assinatura SaaS, agendamentos, gestão de clientes e integração com WhatsApp e Mercado Pago.

## 📋 Sobre o Projeto

O **BarberApp** é uma plataforma SaaS (Software as a Service) que permite barbeiros gerenciarem seus negócios de forma profissional através de um aplicativo mobile. O sistema funciona com modelo de assinatura mensal, onde barbeiros pagam uma mensalidade para utilizar todas as funcionalidades da plataforma.

### Modelo de Negócio

- **Administrador**: Você, como desenvolvedor, tem controle total da plataforma
- **Barbeiros**: Assinantes mensais que utilizam o app para gerenciar clientes
- **Clientes**: Usuários finais que agendam serviços com os barbeiros

## ✨ Funcionalidades Principais

### Para Administradores
- Dashboard completo com métricas da plataforma
- Gerenciamento de barbeiros (aprovar, suspender, excluir)
- Controle de pagamentos e mensalidades
- Relatórios financeiros detalhados

### Para Barbeiros
- Gerenciamento completo de clientes
- Sistema de agendamentos com calendário
- Cadastro de serviços e preços
- Criação e envio de promoções
- Integração com WhatsApp para contato direto
- Gestão de assinatura e pagamentos

### Para Clientes
- Busca de barbeiros próximos
- Agendamento de horários online
- Histórico de cortes
- Recebimento de promoções
- Avaliação de barbeiros

## 🚀 Tecnologias Utilizadas

- **Flutter 3.24.5** - Framework multiplataforma
- **Firebase** - Backend as a Service (Authentication, Firestore, Storage, FCM)
- **Mercado Pago API** - Pagamentos e assinaturas
- **Provider** - Gerenciamento de estado
- **GoRouter** - Navegação

## 📦 Pré-requisitos

- Flutter SDK (versão 3.24.5 ou superior)
- Dart SDK (versão 3.5.4 ou superior)
- Android Studio ou Xcode
- Conta no Firebase
- Conta no Mercado Pago

## 🔧 Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/WallisonWS/app-de-barbearia-flutter.git
cd app-de-barbearia-flutter
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure o Firebase

Siga o guia detalhado em [CONFIGURACAO_FIREBASE.md](./CONFIGURACAO_FIREBASE.md)

### 4. Execute o projeto

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 📁 Estrutura do Projeto

```
lib/
├── core/                 # Constantes, utilitários, widgets base
├── data/                 # Modelos, repositórios, datasources
├── domain/               # Entidades, casos de uso
└── presentation/         # Telas, providers, widgets
```

Arquitetura: **Clean Architecture + MVVM**

## 📚 Documentação

- [ARQUITETURA.md](./ARQUITETURA.md) - Arquitetura do sistema
- [ESPECIFICACOES_TECNICAS.md](./ESPECIFICACOES_TECNICAS.md) - Detalhes técnicos
- [CONFIGURACAO_FIREBASE.md](./CONFIGURACAO_FIREBASE.md) - Configuração Firebase

## 🗺️ Roadmap

### Fase 1 - MVP (Em Desenvolvimento)
- [x] Estrutura base do projeto
- [x] Configuração do Firebase
- [ ] Sistema de autenticação
- [ ] Dashboard básico
- [ ] Sistema de agendamentos

### Fase 2 - Core Features
- [ ] Integração WhatsApp
- [ ] Sistema de promoções
- [ ] Integração Mercado Pago
- [ ] Notificações push

### Fase 3 - Melhorias
- [ ] Sistema de avaliações
- [ ] Busca geolocalizada
- [ ] Relatórios avançados

## 👤 Autor

**Wallison WS**
- GitHub: [@WallisonWS](https://github.com/WallisonWS)

## 📄 Licença

Este projeto está sob a licença MIT.

---

**Desenvolvido com ❤️ usando Flutter**
