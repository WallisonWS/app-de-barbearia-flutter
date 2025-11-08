import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BarbershopsManagementScreen extends StatefulWidget {
  const BarbershopsManagementScreen({super.key});

  @override
  State<BarbershopsManagementScreen> createState() =>
      _BarbershopsManagementScreenState();
}

class _BarbershopsManagementScreenState
    extends State<BarbershopsManagementScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Gerenciar Barbearias'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textWhite,
          labelColor: AppColors.textWhite,
          unselectedLabelColor: AppColors.textWhite.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Pendentes'),
            Tab(text: 'Inativas'),
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
                hintText: 'Buscar barbearias...',
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

          // Lista de barbearias
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBarbershopsList('all'),
                _buildBarbershopsList('pending'),
                _buildBarbershopsList('inactive'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarbershopsList(String filter) {
    // Mock data - em produção, virá do backend
    final barbershops = _getMockBarbershops(filter);

    if (barbershops.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma barbearia encontrada',
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
      itemCount: barbershops.length,
      itemBuilder: (context, index) {
        final barbershop = barbershops[index];
        return _BarbershopCard(
          name: barbershop['name']!,
          owner: barbershop['owner']!,
          address: barbershop['address']!,
          rating: barbershop['rating']!,
          status: barbershop['status']!,
          onTap: () {
            _showBarbershopDetails(context, barbershop);
          },
        );
      },
    );
  }

  List<Map<String, String>> _getMockBarbershops(String filter) {
    final all = [
      {
        'name': 'Barbearia Premium',
        'owner': 'João Silva',
        'address': 'Rua das Flores, 123 - Centro',
        'rating': '4.8',
        'status': 'active',
      },
      {
        'name': 'Corte & Estilo',
        'owner': 'Pedro Santos',
        'address': 'Av. Principal, 456 - Jardim',
        'rating': '4.9',
        'status': 'active',
      },
      {
        'name': 'Barbershop Clássico',
        'owner': 'Carlos Oliveira',
        'address': 'Rua do Comércio, 789 - Vila Nova',
        'rating': '4.7',
        'status': 'pending',
      },
      {
        'name': 'Estilo Masculino',
        'owner': 'Rafael Costa',
        'address': 'Av. Central, 321 - Centro',
        'rating': '4.6',
        'status': 'inactive',
      },
    ];

    if (filter == 'pending') {
      return all.where((b) => b['status'] == 'pending').toList();
    } else if (filter == 'inactive') {
      return all.where((b) => b['status'] == 'inactive').toList();
    }

    return all;
  }

  void _showBarbershopDetails(
      BuildContext context, Map<String, String> barbershop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
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

                // Nome
                Text(
                  barbershop['name']!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Proprietário
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Proprietário: ${barbershop['owner']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Endereço
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        barbershop['address']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Avaliação
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      '${barbershop['rating']} (120 avaliações)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
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

                if (barbershop['status'] == 'pending') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Barbearia aprovada com sucesso!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Aprovar Barbearia'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Barbearia rejeitada'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Rejeitar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],

                if (barbershop['status'] == 'active') ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Barbearia desativada'),
                            backgroundColor: AppColors.warning,
                          ),
                        );
                      },
                      icon: const Icon(Icons.block),
                      label: const Text('Desativar Barbearia'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.warning,
                        side: const BorderSide(color: AppColors.warning),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],

                if (barbershop['status'] == 'inactive') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Barbearia reativada com sucesso!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Reativar Barbearia'),
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
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Ver Detalhes Completos'),
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

class _BarbershopCard extends StatelessWidget {
  final String name;
  final String owner;
  final String address;
  final String rating;
  final String status;
  final VoidCallback onTap;

  const _BarbershopCard({
    required this.name,
    required this.owner,
    required this.address,
    required this.rating,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _StatusBadge(status: status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    owner,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'active':
        color = AppColors.success;
        label = 'Ativa';
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'Pendente';
        break;
      case 'inactive':
        color = AppColors.error;
        label = 'Inativa';
        break;
      default:
        color = AppColors.textSecondary;
        label = 'Desconhecido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
