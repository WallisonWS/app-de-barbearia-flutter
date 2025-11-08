# 🧪 Guia de Testes - App de Barbearia

Este guia apresenta os passos para testar todas as funcionalidades implementadas no aplicativo de barbearia.

---

## 📱 Preparação

Antes de começar os testes, certifique-se de que o aplicativo está rodando no seu dispositivo (emulador ou celular físico).

### Comandos para Atualizar o App

```bash
cd "C:\app barbearia\app-de-barbearia-flutter"
git pull origin main
flutter clean
flutter pub get
flutter run
```

---

## 🔐 Testando o Sistema de Autenticação

### 1. Tela Inicial (Seleção de Perfil)

**O que testar:**
- Visualize a tela de boas-vindas com o logo e nome do app
- Verifique se aparecem dois cards: "Barbeiro" e "Cliente"
- Procure o botão "Acesso Administrativo" na parte inferior

**Ações:**
- Clique em cada card e verifique se abre a tela de login correspondente
- Volte e teste o botão "Acesso Administrativo"

### 2. Tela de Login

**O que testar:**
- Tente fazer login sem preencher os campos (deve mostrar erro de validação)
- Digite um email inválido (sem @) e veja a mensagem de erro
- Preencha email e senha (qualquer valor funciona no mock)
- Clique em "Entrar"

**Resultado esperado:**
- Login com sucesso e navegação para o dashboard correto

---

## 👨‍💼 Testando o Painel Administrativo

### 1. Acesso ao Admin

**Passos:**
1. Na tela inicial, clique em "Acesso Administrativo"
2. Faça login com qualquer email/senha
3. Verifique se abre o **Dashboard do Admin**

### 2. Dashboard do Admin

**O que verificar:**
- **Cards de métricas** no topo:
  - Barbearias (15)
  - Usuários (245)
  - Agendamentos (1.234)
  - Receita (R$ 45.678,90)
- **Atividades recentes** abaixo das métricas
- **Botões de ação rápida:**
  - Gerenciar Barbearias
  - Gerenciar Usuários

**Ações:**
- Clique em "Gerenciar Barbearias"
- Volte e clique em "Gerenciar Usuários"

### 3. Gerenciamento de Barbearias

**O que testar:**
- **Tabs de filtro:** Todas / Pendentes / Inativas
- **Busca:** Digite um nome e veja a filtragem
- **Cards de barbearias:** Verifique as informações exibidas
- **Clique em um card:** Deve abrir bottom sheet com detalhes

**Ações no Bottom Sheet:**
- Teste o botão "Aprovar" (para pendentes)
- Teste o botão "Rejeitar" (para pendentes)
- Teste o botão "Desativar" (para ativas)
- Teste o botão "Reativar" (para inativas)
- Verifique se aparecem diálogos de confirmação

### 4. Gerenciamento de Usuários

**O que testar:**
- **Tabs de filtro:** Todos / Clientes / Barbeiros
- **Busca:** Digite um nome ou email
- **Cards de usuários:** Verifique informações e badges
- **Clique em um card:** Deve abrir bottom sheet

**Ações no Bottom Sheet:**
- Teste o botão "Bloquear Usuário"
- Teste o botão "Desbloquear Usuário" (para bloqueados)
- Teste o botão "Ver Histórico" (mostrará mensagem de desenvolvimento)

### 5. Perfil do Admin

**Passos:**
1. No dashboard, clique no ícone de perfil no AppBar
2. Verifique as informações exibidas
3. Teste o botão "Editar Perfil"
4. Teste o botão "Sair" (deve pedir confirmação)

---

## 💈 Testando Funcionalidades da Barbearia

### 1. Acesso como Barbeiro

**Passos:**
1. Faça logout do admin
2. Na tela inicial, clique em "Barbeiro"
3. Faça login
4. Verifique se abre o **Dashboard do Barbeiro**

### 2. Dashboard do Barbeiro

**O que verificar:**
- **Cards de estatísticas:**
  - Agendamentos Hoje (12)
  - Clientes (45)
  - Avaliação (4.8)
- **Ações rápidas (4 cards em 2 linhas):**
  - Minha Barbearia
  - Agenda
  - Clientes
  - Serviços
  - Promoções (pode estar como segundo card da segunda linha)
- **Próximos agendamentos:** Lista com horários

**Ações:**
- Clique em "Minha Barbearia"

### 3. Perfil da Barbearia

**O que verificar:**
- **Header com gradiente:**
  - Foto da barbearia (ícone de loja)
  - Nome: "Barbearia Premium"
  - Avaliação: 4.8 (120 avaliações)
  - Ícone de câmera para alterar foto
- **Seção "Sobre":** Descrição da barbearia
- **Informações de Contato (4 cards):**
  - Endereço
  - Telefone
  - Email
  - Horário de funcionamento
- **Galeria:** Lista horizontal de placeholders de fotos
- **Serviços Oferecidos (3 serviços):**
  - Corte de Cabelo - R$ 45,00 - 30 min
  - Barba - R$ 30,00 - 20 min
  - Corte + Barba - R$ 65,00 - 45 min

**Ações:**
- Clique no botão "Editar" no AppBar (mostrará mensagem de desenvolvimento)
- Clique em "Adicionar" na galeria
- Clique em "Gerenciar" nos serviços
- Volte para o dashboard

### 4. Outras Funcionalidades do Barbeiro

**Teste os cards de ação rápida:**
- **Agenda:** Deve mostrar mensagem de desenvolvimento
- **Clientes:** Deve mostrar mensagem de desenvolvimento
- **Serviços:** Deve mostrar mensagem de desenvolvimento
- **Promoções:** Deve mostrar mensagem de desenvolvimento

---

## 👥 Testando Funcionalidades do Cliente

### 1. Acesso como Cliente

**Passos:**
1. Faça logout do barbeiro
2. Na tela inicial, clique em "Cliente"
3. Faça login
4. Verifique se abre a **Home do Cliente**

### 2. Home do Cliente

**O que verificar:**
- **Header personalizado:**
  - Saudação: "Olá, [Nome]!"
  - Localização: "São Paulo, SP"
- **Barra de busca:** "Buscar barbearias..."
- **Categorias de serviços (3 cards):**
  - Corte
  - Barba
  - Completo
- **Barbeiros em Destaque:**
  - Título com botão "Ver todos"
  - 3 cards de barbeiros:
    - João Silva - 4.8 (120) - 1.2 km
    - Pedro Santos - 4.9 (95) - 2.5 km
    - Carlos Oliveira - 4.7 (150) - 3.1 km
- **Meus Agendamentos:** Lista de próximos horários

**Ações:**
- Clique na barra de busca (mostrará mensagem de desenvolvimento)
- Clique em uma categoria de serviço
- **IMPORTANTE:** Clique em um card de barbeiro

### 3. Detalhes da Barbearia

**O que verificar:**
- **AppBar expansível:**
  - Imagem da barbearia em tela cheia (ou ícone com gradiente)
  - Gradient overlay escuro na parte inferior
  - Botão de favorito (coração) no canto superior direito
- **Informações principais:**
  - Nome do barbeiro clicado
  - Badge de avaliação: 4.8 (120)
  - Distância: 1.2 km
- **Seção "Sobre":** Descrição completa
- **Seção "Informações" (3 itens):**
  - Endereço com ícone de localização
  - Telefone com ícone de telefone
  - Horário com ícone de relógio
- **Seção "Serviços" (3 serviços):**
  - Cada serviço com ícone, nome, duração e preço
- **Seção "Avaliações" (2 avaliações):**
  - João Silva - 5 estrelas - "Excelente atendimento..."
  - Pedro Santos - 4.5 estrelas - "Muito bom..."
  - Botão "Ver todas"
- **Botão flutuante:** "Agendar" (canto inferior direito)

**Ações:**
- Clique no botão de favorito (deve mostrar snackbar)
- Role a tela para ver todo o conteúdo
- Clique em "Ver todas" nas avaliações
- Clique no botão "Agendar"
- Volte para a home

### 4. Perfil do Cliente

**Passos:**
1. Na home, clique no ícone de perfil no AppBar
2. Verifique as informações exibidas
3. Teste o botão "Editar Perfil"
4. Na tela de edição, altere o nome ou telefone
5. Clique em "Salvar"
6. Volte e verifique se as alterações foram salvas

---

## 🔄 Testando Edição de Perfil

### Para Qualquer Tipo de Usuário

**Passos:**
1. Acesse o perfil (ícone no AppBar)
2. Clique em "Editar Perfil"
3. **Teste a foto:**
   - Clique no ícone de câmera (mostrará mensagem de desenvolvimento)
4. **Teste o nome:**
   - Altere o nome
   - Tente deixar vazio (deve mostrar erro)
5. **Teste o telefone:**
   - Digite um telefone inválido (menos de 10 dígitos)
   - Veja a mensagem de erro
   - Digite um telefone válido
6. Clique em "Salvar"
7. Volte para o perfil e verifique as alterações

---

## 🚪 Testando Logout

### Em Qualquer Dashboard

**Passos:**
1. Clique no ícone de logout no AppBar (ou no botão "Sair" no perfil)
2. Verifique se aparece diálogo de confirmação
3. Clique em "Cancelar" (deve fechar o diálogo)
4. Clique novamente em logout
5. Clique em "Sair" (deve voltar para tela inicial)

---

## ✅ Checklist de Testes

Use este checklist para garantir que testou todas as funcionalidades:

### Autenticação
- [ ] Tela de seleção de perfil
- [ ] Login como Admin
- [ ] Login como Barbeiro
- [ ] Login como Cliente
- [ ] Validação de campos
- [ ] Logout

### Admin
- [ ] Dashboard com métricas
- [ ] Gerenciamento de barbearias
- [ ] Filtros de barbearias (Todas/Pendentes/Inativas)
- [ ] Busca de barbearias
- [ ] Aprovar barbearia
- [ ] Rejeitar barbearia
- [ ] Desativar barbearia
- [ ] Reativar barbearia
- [ ] Gerenciamento de usuários
- [ ] Filtros de usuários (Todos/Clientes/Barbeiros)
- [ ] Busca de usuários
- [ ] Bloquear usuário
- [ ] Desbloquear usuário
- [ ] Perfil do admin
- [ ] Editar perfil do admin

### Barbeiro
- [ ] Dashboard com estatísticas
- [ ] Ações rápidas (4 cards)
- [ ] Perfil da barbearia
- [ ] Informações de contato
- [ ] Galeria de fotos
- [ ] Lista de serviços
- [ ] Próximos agendamentos
- [ ] Perfil do barbeiro
- [ ] Editar perfil do barbeiro

### Cliente
- [ ] Home com header personalizado
- [ ] Barra de busca
- [ ] Categorias de serviços
- [ ] Lista de barbeiros em destaque
- [ ] Navegação para detalhes da barbearia
- [ ] Detalhes da barbearia (AppBar expansível)
- [ ] Favoritar/desfavoritar
- [ ] Informações da barbearia
- [ ] Lista de serviços
- [ ] Avaliações
- [ ] Botão de agendar
- [ ] Meus agendamentos
- [ ] Perfil do cliente
- [ ] Editar perfil do cliente

### Geral
- [ ] Navegação entre telas
- [ ] Botões de voltar
- [ ] Mensagens de confirmação
- [ ] Mensagens de erro
- [ ] Snackbars informativos
- [ ] Bottom sheets
- [ ] Diálogos
- [ ] Responsividade (teste em diferentes tamanhos de tela)

---

## 🐛 Reportando Problemas

Se encontrar algum problema durante os testes, anote:

1. **Tipo de usuário:** Admin / Barbeiro / Cliente
2. **Tela onde ocorreu:** Nome da tela
3. **Ação realizada:** O que você clicou/fez
4. **Resultado esperado:** O que deveria acontecer
5. **Resultado obtido:** O que realmente aconteceu
6. **Mensagem de erro:** Se houver

---

## 🎯 Conclusão

Após completar todos os testes deste guia, você terá verificado todas as funcionalidades implementadas no aplicativo. 

**Lembre-se:** Algumas funcionalidades mostram a mensagem "Funcionalidade em desenvolvimento" porque a estrutura está pronta, mas aguardam integração com backend.

**Última Atualização:** 08 de Novembro de 2025
