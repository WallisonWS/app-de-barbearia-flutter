import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/contact_utils.dart';

class ClientsManagementScreen extends StatefulWidget {
  const ClientsManagementScreen({super.key});

  @override
  State<ClientsManagementScreen> createState() =>
      _ClientsManagementScreenState();
}

class _ClientsManagementScreenState extends State<ClientsManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, vip, recent

  // Mock data - em produção virá do backend
  final List<Map<String, dynamic>> _mockClients = [
    {
      'id': '1',
      'name': 'João Silva',
      'phone': '11999998888',
      'email': 'joao.silva@email.com',
      'photoUrl': null,
      'totalAppointments': 15,
      'lastAppointment': '05 Nov 2024',
      'isVip': true,
      'totalSpent': 675.00,
    },
    {
      'id': '2',
      'name': 'Pedro Santos',
      'phone': '11988887777',
      'email': 'pedro.santos@email.com',
      'photoUrl': null,
      'totalAppointments': 8,
      'lastAppointment': '03 Nov 2024',
      'isVip': false,
      'totalSpent': 360.00,
    },
    {
      'id': '3',
      'name': 'Carlos Oliveira',
      'phone': '11977776666',
      'email': 'carlos.oliveira@email.com',
      'photoUrl': null,
      'totalAppointments': 22,
      'lastAppointment': '07 Nov 2024',
      'isVip': true,
      'totalSpent': 990.00,
    },
    {
      'id': '4',
      'name': 'Lucas Ferreira',
      'phone': '11966665555',
      'email': 'lucas.ferreira@email.com',
      'photoUrl': null,
      'totalAppointments': 3,
      'lastAppointment': '01 Nov 2024',
      'isVip': false,
      'totalSpent': 135.00,
    },
    {
      'id': '5',
      'name': 'Rafael Costa',
      'phone': '11955554444',
      'email': 'rafael.costa@email.com',
      'photoUrl': null,
      'totalAppointments': 12,
      'lastAppointment': '06 Nov 2024',
      'isVip': true,
      'totalSpent': 540.00,
    },
  ];

  List<Map<String, dynamic>> get _filteredClients {
    var clients = _mockClients;

    // Filtro por tipo
    if (_selectedFilter == 'vip') {
      clients = clients.where((c) => c['isVip'] == true).toList();
    } else if (_selectedFilter == 'recent') {
      // Ordena por data do último agendamento (mock - em produção seria por data real)
      clients = List.from(clients)
        ..sort((a, b) => b['lastAppointment']
            .toString()
            .compareTo(a['lastAppointment'].toString()));
      clients = clients.take(10).toList();
    }

    // Filtro por busca
    if (_searchQuery.isNotEmpty) {
      clients = clients
          .where((client) =>
              client['name']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              client['phone'].toString().contains(_searchQuery))
          .toList();
    }

    return clients;
  }

  void _showClientDetails(Map<String, dynamic> client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ClientDetailsSheet(client: client),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Clientes'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Mostrar opções de filtro avançado
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busca
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar cliente por nome ou telefone...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.textWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Filtros rápidos
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todos',
                  isSelected: _selectedFilter == 'all',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'all';
                    });
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'VIP',
                  isSelected: _selectedFilter == 'vip',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'vip';
                    });
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Recentes',
                  isSelected: _selectedFilter == 'recent',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'recent';
                    });
                  },
                ),
              ],
            ),
          ),

          // Estatísticas rápidas
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.people,
                    label: 'Total',
                    value: _mockClients.length.toString(),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.star,
                    label: 'VIP',
                    value: _mockClients
                        .where((c) => c['isVip'] == true)
                        .length
                        .toString(),
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.calendar_today,
                    label: 'Este Mês',
                    value: '12',
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),

          // Lista de clientes
          Expanded(
            child: _filteredClients.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum cliente encontrado',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = _filteredClients[index];
                      return _ClientCard(
                        client: client,
                        onTap: () => _showClientDetails(client),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textHint,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final Map<String, dynamic> client;
  final VoidCallback onTap;

  const _ClientCard({
    required this.client,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: AppColors.primary,
                    ),
                  ),
                  if (client['isVip'] == true)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.warning,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          size: 12,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Informações
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client['name'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ContactUtils.formatPhoneNumber(client['phone'] as String),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${client['totalAppointments']} agendamentos',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Botão WhatsApp
              IconButton(
                onPressed: () async {
                  final success = await ContactUtils.openWhatsApp(
                    phoneNumber: client['phone'] as String,
                    message:
                        'Olá ${client['name']}! Tudo bem? Aqui é da Barbearia Premium.',
                  );

                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Não foi possível abrir o WhatsApp'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.chat,
                  color: AppColors.success,
                ),
                tooltip: 'WhatsApp',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> client;

  const _ClientDetailsSheet({required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          client['name'] as String,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (client['isVip'] == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: AppColors.textWhite,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'VIP',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cliente desde ${client['lastAppointment']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Estatísticas
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  icon: Icons.calendar_today,
                  label: 'Agendamentos',
                  value: client['totalAppointments'].toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoBox(
                  icon: Icons.attach_money,
                  label: 'Total Gasto',
                  value: 'R\$ ${client['totalSpent'].toStringAsFixed(2)}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Informações de contato
          Text(
            'Informações de Contato',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          _ContactRow(
            icon: Icons.phone,
            label: 'Telefone',
            value: ContactUtils.formatPhoneNumber(client['phone'] as String),
            onTap: () async {
              await ContactUtils.makePhoneCall(client['phone'] as String);
            },
          ),
          const SizedBox(height: 12),

          _ContactRow(
            icon: Icons.email,
            label: 'Email',
            value: client['email'] as String,
            onTap: () async {
              await ContactUtils.sendEmail(
                email: client['email'] as String,
                subject: 'Contato - Barbearia Premium',
              );
            },
          ),

          const SizedBox(height: 24),

          // Botões de ação
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final success = await ContactUtils.openWhatsApp(
                      phoneNumber: client['phone'] as String,
                      message:
                          'Olá ${client['name']}! Tudo bem? Aqui é da Barbearia Premium.',
                    );

                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Não foi possível abrir o WhatsApp'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.textWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Agendar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
