import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class PromotionsManagementScreen extends StatefulWidget {
  const PromotionsManagementScreen({super.key});

  @override
  State<PromotionsManagementScreen> createState() =>
      _PromotionsManagementScreenState();
}

class _PromotionsManagementScreenState
    extends State<PromotionsManagementScreen> {
  // Mock data - em produção virá do backend
  List<PromotionItem> promotions = [
    PromotionItem(
      id: '1',
      title: 'Desconto de Terça',
      description: '20% de desconto em todos os serviços',
      discount: 20,
      validFrom: DateTime.now(),
      validUntil: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
    ),
    PromotionItem(
      id: '2',
      title: 'Combo Especial',
      description: 'Corte + Barba por R\$ 60',
      discount: 10,
      validFrom: DateTime.now(),
      validUntil: DateTime.now().add(const Duration(days: 15)),
      isActive: true,
    ),
  ];

  void _addPromotion() {
    showDialog(
      context: context,
      builder: (context) => PromotionFormDialog(
        onSave: (promotion) {
          setState(() {
            promotions.insert(0, promotion);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Promoção criada com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _editPromotion(PromotionItem promotion) {
    showDialog(
      context: context,
      builder: (context) => PromotionFormDialog(
        promotion: promotion,
        onSave: (updatedPromotion) {
          setState(() {
            final index = promotions.indexWhere((p) => p.id == promotion.id);
            if (index != -1) {
              promotions[index] = updatedPromotion;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Promoção atualizada com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  Future<void> _deletePromotion(PromotionItem promotion) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content:
            Text('Deseja realmente excluir a promoção "${promotion.title}"?'),
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
        promotions.removeWhere((p) => p.id == promotion.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Promoção excluída com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _togglePromotionStatus(PromotionItem promotion) {
    setState(() {
      final index = promotions.indexWhere((p) => p.id == promotion.id);
      if (index != -1) {
        promotions[index] = PromotionItem(
          id: promotion.id,
          title: promotion.title,
          description: promotion.description,
          discount: promotion.discount,
          validFrom: promotion.validFrom,
          validUntil: promotion.validUntil,
          isActive: !promotion.isActive,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          promotion.isActive ? 'Promoção desativada' : 'Promoção ativada',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePromotions = promotions.where((p) => p.isActive).length;
    final inactivePromotions = promotions.length - activePromotions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Promoções'),
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
                  Icons.local_offer,
                  size: 60,
                  color: AppColors.textWhite,
                ),
                const SizedBox(height: 16),
                Text(
                  '${promotions.length} ${promotions.length == 1 ? 'promoção cadastrada' : 'promoções cadastradas'}',
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
                      label: '$activePromotions ativas',
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      label: '$inactivePromotions inativas',
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de promoções
          Expanded(
            child: promotions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 80,
                          color: AppColors.textHint.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma promoção cadastrada',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crie promoções para atrair clientes',
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
                    itemCount: promotions.length,
                    itemBuilder: (context, index) {
                      final promotion = promotions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PromotionCard(
                          promotion: promotion,
                          onEdit: () => _editPromotion(promotion),
                          onDelete: () => _deletePromotion(promotion),
                          onToggleStatus: () =>
                              _togglePromotionStatus(promotion),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPromotion,
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textWhite,
        icon: const Icon(Icons.add),
        label: const Text('Criar Promoção'),
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

class _PromotionCard extends StatelessWidget {
  final PromotionItem promotion;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const _PromotionCard({
    required this.promotion,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _isExpired() {
    return DateTime.now().isAfter(promotion.validUntil);
  }

  int _daysRemaining() {
    return promotion.validUntil.difference(DateTime.now()).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = _isExpired();
    final daysRemaining = _daysRemaining();

    return Container(
      decoration: BoxDecoration(
        color: promotion.isActive && !isExpired
            ? AppColors.surface
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: promotion.isActive && !isExpired
              ? AppColors.secondary.withOpacity(0.3)
              : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: promotion.isActive && !isExpired
                            ? AppColors.secondary.withOpacity(0.1)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.local_offer,
                        color: promotion.isActive && !isExpired
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
                                  promotion.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: promotion.isActive && !isExpired
                                            ? AppColors.textPrimary
                                            : Colors.grey.shade600,
                                      ),
                                ),
                              ),
                              if (!promotion.isActive)
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
                                    'INATIVA',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                )
                              else if (isExpired)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'EXPIRADA',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
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
                            promotion.description,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: promotion.isActive && !isExpired
                                          ? AppColors.textSecondary
                                          : Colors.grey.shade600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: promotion.isActive && !isExpired
                              ? AppColors.warning.withOpacity(0.1)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${promotion.discount}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: promotion.isActive && !isExpired
                                        ? AppColors.warning
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Desconto',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: promotion.isActive && !isExpired
                                        ? AppColors.textSecondary
                                        : Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: promotion.isActive && !isExpired
                              ? AppColors.info.withOpacity(0.1)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              isExpired
                                  ? 'Expirada'
                                  : daysRemaining == 0
                                      ? 'Hoje'
                                      : '$daysRemaining dias',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: promotion.isActive && !isExpired
                                        ? AppColors.info
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              isExpired ? 'Validade' : 'Restantes',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: promotion.isActive && !isExpired
                                        ? AppColors.textSecondary
                                        : Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: promotion.isActive && !isExpired
                          ? AppColors.textSecondary
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatDate(promotion.validFrom)} até ${_formatDate(promotion.validUntil)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: promotion.isActive && !isExpired
                                ? AppColors.textSecondary
                                : Colors.grey.shade600,
                          ),
                    ),
                  ],
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
                if (!isExpired)
                  TextButton.icon(
                    onPressed: onToggleStatus,
                    icon: Icon(
                      promotion.isActive
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                    ),
                    label: Text(promotion.isActive ? 'Desativar' : 'Ativar'),
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

class PromotionFormDialog extends StatefulWidget {
  final PromotionItem? promotion;
  final Function(PromotionItem) onSave;

  const PromotionFormDialog({
    super.key,
    this.promotion,
    required this.onSave,
  });

  @override
  State<PromotionFormDialog> createState() => _PromotionFormDialogState();
}

class _PromotionFormDialogState extends State<PromotionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _discountController;
  late DateTime _validFrom;
  late DateTime _validUntil;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.promotion?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.promotion?.description ?? '');
    _discountController = TextEditingController(
      text: widget.promotion?.discount.toString() ?? '',
    );
    _validFrom = widget.promotion?.validFrom ?? DateTime.now();
    _validUntil = widget.promotion?.validUntil ??
        DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _validFrom : _validUntil,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _validFrom = picked;
          if (_validFrom.isAfter(_validUntil)) {
            _validUntil = _validFrom.add(const Duration(days: 7));
          }
        } else {
          _validUntil = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final promotion = PromotionItem(
      id: widget.promotion?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      discount: int.parse(_discountController.text),
      validFrom: _validFrom,
      validUntil: _validUntil,
      isActive: widget.promotion?.isActive ?? true,
    );

    widget.onSave(promotion);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.promotion == null ? 'Criar Promoção' : 'Editar Promoção',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título da Promoção',
                  prefixIcon: const Icon(Icons.local_offer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
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
              TextFormField(
                controller: _discountController,
                decoration: InputDecoration(
                  labelText: 'Desconto (%)',
                  prefixIcon: const Icon(Icons.percent),
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
                    return 'Por favor, insira o desconto';
                  }
                  final discount = int.tryParse(value);
                  if (discount == null || discount < 1 || discount > 100) {
                    return 'Desconto deve ser entre 1 e 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Válido de',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_formatDate(_validFrom)),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Válido até',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_formatDate(_validUntil)),
                ),
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

class PromotionItem {
  final String id;
  final String title;
  final String description;
  final int discount;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;

  PromotionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
  });
}
