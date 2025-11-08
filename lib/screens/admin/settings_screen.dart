import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _maintenanceMode = false;
  bool _allowNewRegistrations = true;
  bool _requireEmailVerification = true;
  bool _enableNotifications = true;
  bool _enableWhatsAppIntegration = true;
  
  final TextEditingController _platformNameController = TextEditingController(text: 'BarberApp');
  final TextEditingController _supportEmailController = TextEditingController(text: 'suporte@barberapp.com');
  final TextEditingController _supportPhoneController = TextEditingController(text: '+55 11 99999-9999');
  final TextEditingController _maxBarbershopsController = TextEditingController(text: '1000');
  final TextEditingController _commissionRateController = TextEditingController(text: '10');

  @override
  void dispose() {
    _platformNameController.dispose();
    _supportEmailController.dispose();
    _supportPhoneController.dispose();
    _maxBarbershopsController.dispose();
    _commissionRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações da Plataforma'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações Gerais
            const Text(
              'Informações Gerais',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _platformNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Plataforma',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _supportEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Email de Suporte',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _supportPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone de Suporte',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Configurações de Negócio
            const Text(
              'Configurações de Negócio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _maxBarbershopsController,
                      decoration: const InputDecoration(
                        labelText: 'Máximo de Barbearias',
                        prefixIcon: Icon(Icons.store),
                        border: OutlineInputBorder(),
                        helperText: 'Limite de barbearias cadastradas na plataforma',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _commissionRateController,
                      decoration: const InputDecoration(
                        labelText: 'Taxa de Comissão (%)',
                        prefixIcon: Icon(Icons.percent),
                        border: OutlineInputBorder(),
                        helperText: 'Comissão sobre transações (futuro)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Configurações do Sistema
            const Text(
              'Configurações do Sistema',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Modo Manutenção'),
                    subtitle: const Text('Desabilita acesso de usuários'),
                    value: _maintenanceMode,
                    activeColor: const Color(0xFF8B4513),
                    onChanged: (bool value) {
                      setState(() {
                        _maintenanceMode = value;
                      });
                      if (value) {
                        _showMaintenanceModeDialog();
                      }
                    },
                    secondary: const Icon(Icons.build),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Permitir Novos Cadastros'),
                    subtitle: const Text('Permite registro de novas barbearias'),
                    value: _allowNewRegistrations,
                    activeColor: const Color(0xFF8B4513),
                    onChanged: (bool value) {
                      setState(() {
                        _allowNewRegistrations = value;
                      });
                    },
                    secondary: const Icon(Icons.person_add),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Verificação de Email'),
                    subtitle: const Text('Requer verificação de email no cadastro'),
                    value: _requireEmailVerification,
                    activeColor: const Color(0xFF8B4513),
                    onChanged: (bool value) {
                      setState(() {
                        _requireEmailVerification = value;
                      });
                    },
                    secondary: const Icon(Icons.verified_user),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Integrações
            const Text(
              'Integrações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Notificações Push'),
                    subtitle: const Text('Ativar notificações push para usuários'),
                    value: _enableNotifications,
                    activeColor: const Color(0xFF8B4513),
                    onChanged: (bool value) {
                      setState(() {
                        _enableNotifications = value;
                      });
                    },
                    secondary: const Icon(Icons.notifications),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Integração WhatsApp'),
                    subtitle: const Text('Permite envio de mensagens via WhatsApp'),
                    value: _enableWhatsAppIntegration,
                    activeColor: const Color(0xFF8B4513),
                    onChanged: (bool value) {
                      setState(() {
                        _enableWhatsAppIntegration = value;
                      });
                    },
                    secondary: const Icon(Icons.chat),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Planos e Preços
            const Text(
              'Planos e Preços',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.workspace_premium, color: Colors.grey),
                    title: const Text('Plano Grátis'),
                    subtitle: const Text('R\$ 0,00/mês'),
                    trailing: TextButton(
                      onPressed: () => _editPlan('Grátis'),
                      child: const Text('Editar'),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.workspace_premium, color: Color(0xFF8B4513)),
                    title: const Text('Plano Premium'),
                    subtitle: const Text('R\$ 29,90/mês'),
                    trailing: TextButton(
                      onPressed: () => _editPlan('Premium'),
                      child: const Text('Editar'),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.workspace_premium, color: Colors.amber),
                    title: const Text('Plano Profissional'),
                    subtitle: const Text('R\$ 79,90/mês'),
                    trailing: TextButton(
                      onPressed: () => _editPlan('Profissional'),
                      child: const Text('Editar'),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Ações Perigosas
            const Text(
              'Zona de Perigo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              color: Colors.red[50],
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Limpar Cache do Sistema'),
                    subtitle: const Text('Remove dados temporários'),
                    trailing: ElevatedButton(
                      onPressed: _clearCache,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Limpar'),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.restart_alt, color: Colors.orange),
                    title: const Text('Resetar Configurações'),
                    subtitle: const Text('Volta para configurações padrão'),
                    trailing: ElevatedButton(
                      onPressed: _resetSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Resetar'),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botão Salvar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Configurações'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMaintenanceModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modo Manutenção'),
        content: const Text(
          'Ativar o modo manutenção irá impedir que usuários acessem a plataforma. '
          'Apenas administradores poderão fazer login.\n\n'
          'Tem certeza que deseja continuar?'
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _maintenanceMode = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modo manutenção ativado!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Ativar'),
          ),
        ],
      ),
    );
  }
  
  void _editPlan(String planName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Plano $planName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Preço (R\$)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Plano $planName atualizado!')),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  
  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Cache'),
        content: const Text('Tem certeza que deseja limpar o cache do sistema?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache limpo com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }
  
  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resetar Configurações'),
        content: const Text(
          'Tem certeza que deseja resetar todas as configurações para os valores padrão?\n\n'
          'Esta ação não pode ser desfeita.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Configurações resetadas!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Resetar'),
          ),
        ],
      ),
    );
  }
  
  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configurações salvas com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
