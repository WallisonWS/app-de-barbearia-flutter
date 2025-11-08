import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Usuários'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textWhite,
          labelColor: AppColors.textWhite,
          unselectedLabelColor: AppColors.textWhite.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Todos'),
            Tab(text: 'Clientes'),
            Tab(text: 'Barbeiros'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar usuários...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Lista de usuários
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsersList('all'),
                _buildUsersList('client'),
                _buildUsersList('barber'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(String filter) {
    // Mock data - em produção, virá do backend
    final users = _getMockUsers(filter);

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outlined,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum usuário encontrado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _UserCard(
          name: user['name']!,
          email: user['email']!,
          phone: user['phone']!,
          role: user['role']!,
          status: user['status']!,
          onTap: () {
            _showUserDetails(context, user);
          },
        );
      },
    );
  }

  List<Map<String, String>> _getMockUsers(String filter) {
    final all = [
      {
        'name': 'João Silva',
        'email': 'joao@email.com',
        'phone': '(11) 98765-4321',
        'role': 'barber',
        'status': 'active',
      },
      {
        'name': 'Maria Santos',
        'email': 'maria@email.com',
        'phone': '(11) 98765-1234',
        'role': 'client',
        'status': 'active',
      },
      {
        'name': 'Pedro Costa',
        'email': 'pedro@email.com',
        'phone': '(11) 98765-5678',
        'role': 'barber',
        'status': 'active',
      },
      {
        'name': 'Ana Oliveira',
        'email': 'ana@email.com',
        'phone': '(11) 98765-9012',
        'role': 'client',
        'status': 'blocked',
      },
      {
        'name': 'Carlos Souza',
        'email': 'carlos@email.com',
        'phone': '(11) 98765-3456',
        'role': 'client',
        'status': 'active',
      },
    ];

    if (filter == 'client') {
      return all.where((u) => u['role'] == 'client').toList();
    } else if (filter == 'barber') {
      return all.where((u) => u['role'] == 'barber').toList();
    }

    return all;
  }

  void _showUserDetails(BuildContext context, Map<String, String> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textHint,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Foto e nome
                Center(
                  child: Column(
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
                      const SizedBox(height: 12),
                      Text(
                        user['name']!,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      _RoleBadge(role: user['role']!),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Informações
                Text(
                  'Informações',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user['email']!,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Telefone',
                  value: user['phone']!,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Membro desde',
                  value: '15 Jan 2024',
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Ações
                Text(
                  'Ações',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                if (user['status'] == 'active') ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuário bloqueado'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      },
                      icon: const Icon(Icons.block),
                      label: const Text('Bloquear Usuário'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],

                if (user['status'] == 'blocked') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuário desbloqueado com sucesso!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Desbloquear Usuário'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidade em desenvolvimento'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Ver Histórico de Atividades'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final VoidCallback onTap;

  const _UserCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
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
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  size: 28,
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
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (status == 'blocked')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Bloqueado',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          phone,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(width: 12),
                        _RoleBadge(role: role),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (role) {
      case 'barber':
        color = AppColors.primary;
        label = 'Barbeiro';
        icon = Icons.content_cut;
        break;
      case 'client':
        color = AppColors.info;
        label = 'Cliente';
        icon = Icons.person;
        break;
      default:
        color = AppColors.textSecondary;
        label = 'Desconhecido';
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
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
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
