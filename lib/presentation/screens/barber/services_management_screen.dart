import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class ServicesManagementScreen extends StatefulWidget {
  const ServicesManagementScreen({super.key});

  @override
  State<ServicesManagementScreen> createState() =>
      _ServicesManagementScreenState();
}

class _ServicesManagementScreenState extends State<ServicesManagementScreen> {
  // Mock data - em produção virá do backend
  List<ServiceItem> services = [
    ServiceItem(
      id: '1',
      name: 'Corte de Cabelo',
      description: 'Corte moderno e personalizado',
      price: 45.00,
      duration: 30,
      isActive: true,
    ),
    ServiceItem(
      id: '2',
      name: 'Barba',
      description: 'Aparar e modelar barba',
      price: 30.00,
      duration: 20,
      isActive: true,
    ),
    ServiceItem(
      id: '3',
      name: 'Corte + Barba',
      description: 'Combo completo',
      price: 65.00,
      duration: 45,
      isActive: true,
    ),
  ];

  void _addService() {
    showDialog(
      context: context,
      builder: (context) => ServiceFormDialog(
        onSave: (service) {
          setState(() {
            services.add(service);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Serviço adicionado com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _editService(ServiceItem service) {
    showDialog(
      context: context,
      builder: (context) => ServiceFormDialog(
        service: service,
        onSave: (updatedService) {
          setState(() {
            final index = services.indexWhere((s) => s.id == service.id);
            if (index != -1) {
              services[index] = updatedService;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Serviço atualizado com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteService(ServiceItem service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o serviço "${service.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        services.removeWhere((s) => s.id == service.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Serviço excluído com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _toggleServiceStatus(ServiceItem service) {
    setState(() {
      final index = services.indexWhere((s) => s.id == service.id);
      if (index != -1) {
        services[index] = ServiceItem(
          id: service.id,
          name: service.name,
          description: service.description,
          price: service.price,
          duration: service.duration,
          isActive: !service.isActive,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          service.isActive
              ? 'Serviço desativado'
              : 'Serviço ativado',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeServices = services.where((s) => s.isActive).length;
    final inactiveServices = services.length - activeServices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Serviços'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
      ),
      body: Column(
        children: [
          // Header com estatísticas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.content_cut,
                  size: 60,
                  color: AppColors.textWhite,
                ),
                const SizedBox(height: 16),
                Text(
                  '${services.length} ${services.length == 1 ? 'serviço cadastrado' : 'serviços cadastrados'}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatChip(
                      label: '$activeServices ativos',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      label: '$inactiveServices inativos',
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de serviços
          Expanded(
            child: services.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.content_cut_outlined,
                          size: 80,
                          color: AppColors.textHint.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum serviço cadastrado',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicione serviços para começar',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textHint,
                                  ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ServiceCard(
                          service: service,
                          onEdit: () => _editService(service),
                          onDelete: () => _deleteService(service),
                          onToggleStatus: () => _toggleServiceStatus(service),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addService,
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textWhite,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Serviço'),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const _ServiceCard({
    required this.service,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: service.isActive ? AppColors.surface : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: service.isActive
              ? AppColors.textHint.withOpacity(0.2)
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: service.isActive
                        ? AppColors.secondary.withOpacity(0.1)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.content_cut,
                    color: service.isActive
                        ? AppColors.secondary
                        : Colors.grey.shade600,
                    size: 24,
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
                              service.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: service.isActive
                                        ? AppColors.textPrimary
                                        : Colors.grey.shade600,
                                  ),
                            ),
                          ),
                          if (!service.isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'INATIVO',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: service.isActive
                                  ? AppColors.textSecondary
                                  : Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: service.isActive
                                ? AppColors.textSecondary
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${service.duration} min',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: service.isActive
                                          ? AppColors.textSecondary
                                          : Colors.grey.shade600,
                                    ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'R\$ ${service.price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: service.isActive
                                      ? AppColors.primary
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onToggleStatus,
                  icon: Icon(
                    service.isActive
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 18,
                  ),
                  label: Text(service.isActive ? 'Desativar' : 'Ativar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.info,
                  ),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Excluir'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceFormDialog extends StatefulWidget {
  final ServiceItem? service;
  final Function(ServiceItem) onSave;

  const ServiceFormDialog({
    super.key,
    this.service,
    required this.onSave,
  });

  @override
  State<ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.service?.description ?? '');
    _priceController = TextEditingController(
      text: widget.service?.price.toStringAsFixed(2) ?? '',
    );
    _durationController = TextEditingController(
      text: widget.service?.duration.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final service = ServiceItem(
      id: widget.service?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text.replaceAll(',', '.')),
      duration: int.parse(_durationController.text),
      isActive: widget.service?.isActive ?? true,
    );

    widget.onSave(service);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.service == null ? 'Adicionar Serviço' : 'Editar Serviço',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Serviço',
                  prefixIcon: const Icon(Icons.content_cut),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Preço (R\$)',
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        if (double.tryParse(value.replaceAll(',', '.')) ==
                            null) {
                          return 'Inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: InputDecoration(
                        labelText: 'Duração (min)',
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

class ServiceItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;
  final bool isActive;

  ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.isActive,
  });
}
