import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/contact_utils.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        title: const Text('Meus Agendamentos'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Próximos'),
            Tab(text: 'Concluídos'),
            Tab(text: 'Cancelados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(),
          _buildCompletedTab(),
          _buildCancelledTab(),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    final upcomingBookings = [
      {
        'id': '1',
        'barbershop': 'João Silva Barbearia',
        'service': 'Corte + Barba',
        'professional': 'João Silva',
        'date': '15/11/2024',
        'time': '14:30',
        'price': 70.0,
        'status': 'confirmed',
        'phone': '11987654321',
      },
      {
        'id': '2',
        'barbershop': 'Pedro Santos Barber',
        'service': 'Corte Degradê',
        'professional': 'Pedro Santos',
        'date': '18/11/2024',
        'time': '10:00',
        'price': 55.0,
        'status': 'pending',
        'phone': '11987654322',
      },
    ];

    if (upcomingBookings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today,
        title: 'Nenhum agendamento',
        subtitle: 'Você não tem agendamentos próximos',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingBookings.length,
      itemBuilder: (context, index) {
        final booking = upcomingBookings[index];
        return _buildBookingCard(booking, isUpcoming: true);
      },
    );
  }

  Widget _buildCompletedTab() {
    final completedBookings = [
      {
        'id': '3',
        'barbershop': 'Carlos Oliveira Barber',
        'service': 'Corte Tradicional',
        'professional': 'Carlos Oliveira',
        'date': '05/11/2024',
        'time': '16:00',
        'price': 45.0,
        'status': 'completed',
        'phone': '11987654323',
        'rated': true,
        'rating': 5.0,
      },
    ];

    if (completedBookings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'Nenhum agendamento concluído',
        subtitle: 'Seus agendamentos concluídos aparecerão aqui',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedBookings.length,
      itemBuilder: (context, index) {
        final booking = completedBookings[index];
        return _buildBookingCard(booking, isCompleted: true);
      },
    );
  }

  Widget _buildCancelledTab() {
    final cancelledBookings = [];

    if (cancelledBookings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.cancel_outlined,
        title: 'Nenhum agendamento cancelado',
        subtitle: 'Você não tem agendamentos cancelados',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cancelledBookings.length,
      itemBuilder: (context, index) {
        final booking = cancelledBookings[index];
        return _buildBookingCard(booking, isCancelled: true);
      },
    );
  }

  Widget _buildBookingCard(
    Map<String, dynamic> booking, {
    bool isUpcoming = false,
    bool isCompleted = false,
    bool isCancelled = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isCompleted
                      ? AppColors.success.withOpacity(0.1)
                      : isCancelled
                          ? AppColors.error.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                  isCompleted
                      ? AppColors.success.withOpacity(0.05)
                      : isCancelled
                          ? AppColors.error.withOpacity(0.05)
                          : AppColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.store,
                    color: isCompleted
                        ? AppColors.success
                        : isCancelled
                            ? AppColors.error
                            : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['barbershop'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle
                                : isCancelled
                                    ? Icons.cancel
                                    : booking['status'] == 'confirmed'
                                        ? Icons.check_circle
                                        : Icons.access_time,
                            size: 14,
                            color: isCompleted
                                ? AppColors.success
                                : isCancelled
                                    ? AppColors.error
                                    : booking['status'] == 'confirmed'
                                        ? AppColors.success
                                        : AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCompleted
                                ? 'Concluído'
                                : isCancelled
                                    ? 'Cancelado'
                                    : booking['status'] == 'confirmed'
                                        ? 'Confirmado'
                                        : 'Pendente',
                            style: TextStyle(
                              fontSize: 12,
                              color: isCompleted
                                  ? AppColors.success
                                  : isCancelled
                                      ? AppColors.error
                                      : booking['status'] == 'confirmed'
                                          ? AppColors.success
                                          : AppColors.warning,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  'R\$ ${booking['price']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),

          // Detalhes
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: Icons.content_cut,
                  label: 'Serviço',
                  value: booking['service'] as String,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.person,
                  label: 'Profissional',
                  value: booking['professional'] as String,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'Data',
                        value: booking['date'] as String,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailRow(
                        icon: Icons.access_time,
                        label: 'Horário',
                        value: booking['time'] as String,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Ações
          if (isUpcoming)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ContactUtils.openWhatsApp(
                          booking['phone'] as String,
                          'Olá! Gostaria de confirmar meu agendamento para ${booking['date']} às ${booking['time']}.',
                        );
                      },
                      icon: const Icon(Icons.chat, size: 18),
                      label: const Text('WhatsApp'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF25D366),
                        side: const BorderSide(color: Color(0xFF25D366)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showRescheduleDialog(booking);
                      },
                      icon: const Icon(Icons.edit_calendar, size: 18),
                      label: const Text('Reagendar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showCancelDialog(booking);
                      },
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Avaliação
          if (isCompleted && !(booking['rated'] as bool? ?? false))
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_outline, color: AppColors.warning),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Avalie este atendimento',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showRatingDialog(booking);
                    },
                    child: const Text('Avaliar'),
                  ),
                ],
              ),
            ),

          // Já avaliado
          if (isCompleted && (booking['rated'] as bool? ?? false))
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 8),
                  const Text(
                    'Você avaliou este atendimento',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < (booking['rating'] as double? ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 100,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: Text(
          'Tem certeza que deseja cancelar o agendamento em ${booking['barbershop']} para ${booking['date']} às ${booking['time']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ Agendamento cancelado'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              setState(() {});
            },
            child: const Text(
              'Sim, Cancelar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reagendar'),
        content: const Text(
          'Entre em contato com a barbearia via WhatsApp para reagendar seu horário.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ContactUtils.openWhatsApp(
                booking['phone'] as String,
                'Olá! Gostaria de reagendar meu horário de ${booking['date']} às ${booking['time']}.',
              );
            },
            child: const Text('Abrir WhatsApp'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(Map<String, dynamic> booking) {
    double rating = 0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Avaliar Atendimento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Como foi sua experiência?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: AppColors.warning,
                      size: 32,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        rating = index + 1;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Comentário (opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Conte como foi sua experiência...',
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
            TextButton(
              onPressed: rating > 0
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('⭐ Avaliação enviada com sucesso!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      setState(() {});
                    }
                  : null,
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
