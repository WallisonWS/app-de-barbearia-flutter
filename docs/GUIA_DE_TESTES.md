# 🧪 Guia Completo de Testes

## Como Testar o App de Barbearia

Este guia vai te ensinar a testar todas as funcionalidades do app.

---

## 📋 Pré-requisitos

Antes de começar os testes, certifique-se de que:

- [x] Firebase está configurado (veja `COMO_CONFIGURAR_FIREBASE.md`)
- [x] Arquivo `google-services.json` está em `android/app/`
- [x] App compila sem erros (`flutter run`)
- [x] Você tem um dispositivo Android ou emulador

---

## 🚀 Passo 1: Executar o App

```bash
cd app-de-barbearia-flutter
flutter clean
flutter pub get
flutter run
```

**Resultado esperado:**
- App abre sem erros
- Splash screen aparece por 3 segundos
- Tela de seleção de perfil aparece

---

## 👤 Passo 2: Testar Autenticação

### 2.1 Criar Conta

1. Na tela de seleção, escolha **"Sou Cliente"**
2. Clique em **"Cadastre-se"**
3. Preencha:
   - Nome: `Teste Cliente`
   - Email: `teste@cliente.com`
   - Senha: `teste123`
4. Clique em **"Cadastrar"**

**Resultado esperado:**
- Conta criada com sucesso
- Redirecionado para tela inicial do cliente

### 2.2 Fazer Login

1. Faça logout (se estiver logado)
2. Clique em **"Entrar"**
3. Preencha:
   - Email: `teste@cliente.com`
   - Senha: `teste123`
4. Clique em **"Entrar"**

**Resultado esperado:**
- Login bem-sucedido
- Redirecionado para tela inicial do cliente

### 2.3 Login com Google

1. Clique em **"Continuar com Google"**
2. Selecione sua conta Google
3. Autorize o app

**Resultado esperado:**
- Login com Google bem-sucedido
- Redirecionado para tela apropriada

### 2.4 Recuperar Senha

1. Na tela de login, clique em **"Esqueceu a senha?"**
2. Digite seu email
3. Clique em **"Enviar"**

**Resultado esperado:**
- Email de recuperação enviado
- Mensagem de sucesso exibida

---

## 🏢 Passo 3: Testar como Barbearia

### 3.1 Popular Dados de Teste

**Opção A: Usar dados mockados (já funciona)**

O app já tem dados mockados que funcionam sem Firebase.

**Opção B: Popular Firestore com dados reais**

Execute o script de seed:

```dart
// Adicione no main.dart, dentro do main():
final seedService = SeedDataService();
if (!await seedService.hasData()) {
  await seedService.seedAllData();
}
```

Depois execute o app novamente.

### 3.2 Login como Barbearia

Use as credenciais criadas pelo seed:

- Email: `barbearia1@email.com`
- Senha: `barber123`

**Resultado esperado:**
- Login bem-sucedido
- Dashboard da barbearia aparece

### 3.3 Testar Dashboard

No dashboard, você deve ver:

- [x] Card "Minha Barbearia"
- [x] Card "Agenda"
- [x] Card "Clientes"
- [x] Card "Serviços"
- [x] Card "Promoções"

Clique em cada card e verifique se navega corretamente.

### 3.4 Testar Perfil da Barbearia

1. Clique em **"Minha Barbearia"**
2. Verifique se mostra:
   - Nome da barbearia
   - Descrição
   - Endereço
   - Contato
   - Horários
   - Avaliação

3. Clique em **"Editar"**
4. Altere algum campo
5. Clique em **"Salvar"**

**Resultado esperado:**
- Dados atualizados com sucesso
- Mensagem de confirmação

### 3.5 Testar Galeria

1. No perfil, clique em **"Adicionar"** na galeria
2. Selecione uma foto
3. Verifique se aparece na galeria
4. Clique em uma foto para ver detalhes
5. Clique em **"Excluir"**

**Resultado esperado:**
- Foto adicionada com sucesso
- Foto excluída com sucesso

### 3.6 Testar Serviços

1. No perfil, clique em **"Gerenciar"** em serviços
2. Clique em **"Adicionar Serviço"**
3. Preencha:
   - Nome: `Corte Teste`
   - Descrição: `Teste de serviço`
   - Preço: `40`
   - Duração: `30`
4. Clique em **"Salvar"**

**Resultado esperado:**
- Serviço criado com sucesso
- Aparece na lista

5. Clique em um serviço
6. Clique em **"Editar"**
7. Altere o preço
8. Clique em **"Salvar"**

**Resultado esperado:**
- Serviço atualizado

9. Clique em **"Excluir"**
10. Confirme

**Resultado esperado:**
- Serviço excluído

### 3.7 Testar Promoções

1. No dashboard, clique em **"Promoções"**
2. Clique em **"Adicionar Promoção"**
3. Preencha:
   - Título: `Promoção Teste`
   - Descrição: `Desconto especial`
   - Desconto: `20`
   - Data início: Hoje
   - Data fim: Daqui 7 dias
4. Clique em **"Salvar"**

**Resultado esperado:**
- Promoção criada
- Aparece na lista

### 3.8 Testar Agenda

1. No dashboard, clique em **"Agenda"**
2. Verifique se mostra:
   - Seletor de data
   - Filtros de status
   - Lista de agendamentos (se houver)

3. Navegue entre datas
4. Teste os filtros
5. Clique em um agendamento (se houver)

**Resultado esperado:**
- Modal de detalhes abre
- Botões de ação funcionam

---

## 👨‍💼 Passo 4: Testar como Barbeiro

### 4.1 Login como Barbeiro

- Email: `barbeiro1@email.com`
- Senha: `barber123`

### 4.2 Testar Agenda do Barbeiro

1. Dashboard deve mostrar agenda
2. Clique em **"Agenda"**
3. Verifique:
   - Estatísticas do dia
   - Lista de agendamentos
   - Filtros funcionando

4. Clique em um agendamento
5. Teste ações:
   - Confirmar
   - Iniciar
   - Completar
   - Cancelar

**Resultado esperado:**
- Todas as ações funcionam
- Status atualiza em tempo real

---

## 👤 Passo 5: Testar como Cliente

### 5.1 Login como Cliente

- Email: `cliente1@email.com`
- Senha: `cliente123`

### 5.2 Buscar Barbearias

1. Na tela inicial, veja lista de barbearias
2. Use a barra de busca
3. Clique em uma barbearia

**Resultado esperado:**
- Lista de barbearias aparece
- Busca funciona
- Perfil da barbearia abre

### 5.3 Fazer Agendamento

1. No perfil da barbearia, escolha um serviço
2. Clique em **"Agendar"**
3. Selecione uma data
4. Selecione um horário disponível
5. Clique em **"Confirmar Agendamento"**

**Resultado esperado:**
- Calendário mostra horários disponíveis
- Agendamento criado com sucesso
- Confirmação exibida

### 5.4 Ver Meus Agendamentos

1. No menu, clique em **"Meus Agendamentos"**
2. Veja lista de agendamentos
3. Clique em um agendamento
4. Veja detalhes

**Resultado esperado:**
- Lista de agendamentos aparece
- Detalhes corretos

### 5.5 Cancelar Agendamento

1. Em um agendamento, clique em **"Cancelar"**
2. Confirme o cancelamento

**Resultado esperado:**
- Agendamento cancelado
- Status atualizado

### 5.6 Avaliar Barbearia

1. No perfil da barbearia, clique em avaliações
2. Clique em **"Avaliar"**
3. Dê uma nota (1-5 estrelas)
4. Escreva um comentário
5. Clique em **"Enviar"**

**Resultado esperado:**
- Avaliação enviada
- Aparece na lista

---

## 🔔 Passo 6: Testar Notificações

### 6.1 Permissão de Notificações

1. Na primeira execução, aceite permissão de notificações
2. Verifique no console o token FCM

**Resultado esperado:**
- Permissão concedida
- Token exibido no console

### 6.2 Notificação de Agendamento

1. Como barbeiro, confirme um agendamento
2. Cliente deve receber notificação

**Resultado esperado:**
- Notificação recebida
- Ao clicar, abre o agendamento

---

## 📱 Passo 7: Testar Integrações

### 7.1 WhatsApp

1. No perfil da barbearia, clique no ícone do WhatsApp
2. Verifique se abre o WhatsApp

**Resultado esperado:**
- WhatsApp abre com mensagem pré-formatada

### 7.2 Upload de Imagens

1. Tente adicionar foto de perfil
2. Tente adicionar foto na galeria
3. Tente adicionar foto em serviço

**Resultado esperado:**
- Seletor de imagem abre
- Imagem faz upload
- Imagem aparece no app

---

## ✅ Checklist de Testes

### Autenticação
- [ ] Criar conta
- [ ] Fazer login
- [ ] Login com Google
- [ ] Recuperar senha
- [ ] Logout

### Barbearia
- [ ] Ver dashboard
- [ ] Editar perfil
- [ ] Adicionar foto galeria
- [ ] Excluir foto galeria
- [ ] Criar serviço
- [ ] Editar serviço
- [ ] Excluir serviço
- [ ] Criar promoção
- [ ] Editar promoção
- [ ] Excluir promoção

### Barbeiro
- [ ] Ver agenda
- [ ] Filtrar agendamentos
- [ ] Confirmar agendamento
- [ ] Iniciar atendimento
- [ ] Completar atendimento
- [ ] Cancelar agendamento

### Cliente
- [ ] Buscar barbearias
- [ ] Ver perfil barbearia
- [ ] Fazer agendamento
- [ ] Ver meus agendamentos
- [ ] Cancelar agendamento
- [ ] Avaliar barbearia

### Integrações
- [ ] WhatsApp funciona
- [ ] Upload de imagens funciona
- [ ] Notificações funcionam

---

## 🐛 Problemas Comuns

### App não compila

**Solução:**
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase não conecta

**Solução:**
1. Verifique se `google-services.json` está em `android/app/`
2. Verifique se o package name está correto
3. Execute `flutter clean` e tente novamente

### Imagens não fazem upload

**Solução:**
1. Verifique permissões no AndroidManifest.xml
2. Verifique regras do Storage no Firebase
3. Teste com imagem menor (< 5MB)

### Notificações não chegam

**Solução:**
1. Verifique se permissão foi concedida
2. Verifique se Cloud Messaging está ativado no Firebase
3. Teste em dispositivo real (não funciona bem em emulador)

---

## 📊 Relatório de Testes

Após completar os testes, preencha:

**Data:** ___/___/___

**Dispositivo:** _________________

**Versão Android:** _________________

**Funcionalidades Testadas:** ___/30

**Bugs Encontrados:** _________________

**Observações:**
_________________________________
_________________________________
_________________________________

---

## 🆘 Precisa de Ajuda?

Se encontrar problemas:
1. Reveja este guia
2. Consulte a documentação do Firebase
3. Abra uma issue no GitHub

---

**Tempo estimado de teste:** 1-2 horas  
**Dificuldade:** ⭐⭐⭐☆☆ (Médio)

**Bons testes!** 🧪
