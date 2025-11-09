import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/services/firestore_appointment_service.dart';

/// Tela de agenda do barbeiro com Firebase
class ScheduleScreenFirebase extends StatefulWidget {
  final String barberId;

  const ScheduleScreenFirebase({
    super.key,
    required this.barberId,
  });

  @override
  State<ScheduleScreenFirebase> createState() => _ScheduleScreenFirebaseState();
}

class _ScheduleScreenFirebaseState extends State<ScheduleScreenFirebase> {
  final FirestoreAppointmentService _appointmentService = FirestoreAppointmentService();
  
  DateTime _selectedDate = DateTime.now();
  AppointmentStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Seletor de data
          _buildDateSelector(),

          // Filtros de status
          _buildStatusFilters(),

          // Lista de agendamentos
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: _appointmentService.getBarberAppointmentsStream(widget.barberId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                // Filtrar por data e status
                final appointments = snapshot.data!.where((appointment) {
                  final isSameDate = appointment.dateTime.year == _selectedDate.year &&
                      appointment.dateTime.month == _selectedDate.month &&
                      appointment.dateTime.day == _selectedDate.day;

                  if (!isSameDate) return false;

                  if (_selectedStatus != null && appointment.status != _selectedStatus) {
                    return false;
                  }

                  return true;
                }).toList();

                if (appointments.isEmpty) {
                  return _buildEmptyState();
                }

                // Estatísticas do dia
                final stats = _calculateDayStats(appointments);

                return Column(
                  children: [
                    _buildStatsCards(stats),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          return _buildAppointmentCard(appointments[index]);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.surface,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              child: Column(
                children: [
                  Text(
                    DateFormat('EEEE', 'pt_BR').format(_selectedDate),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Todos', null),
          const SizedBox(width: 8),
          _buildFilterChip('Pendentes', AppointmentStatus.pending),
          const SizedBox(width: 8),
          _buildFilterChip('Confirmados', AppointmentStatus.confirmed),
          const SizedBox(width: 8),
          _buildFilterChip('Em Andamento', AppointmentStatus.inProgress),
          const SizedBox(width: 8),
          _buildFilterChip('Concluídos', AppointmentStatus.completed),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, AppointmentStatus? status) {
    final isSelected = _selectedStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? status : null;
        });
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStatsCards(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Agendamentos',
              stats['total'].toString(),
              Icons.event,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Horas',
              '${stats['hours']}h',
              Icons.access_time,
              AppColors.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Receita',
              'R\$ ${stats['revenue'].toStringAsFixed(0)}',
              Icons.attach_money,
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showAppointmentDetails(appointment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(appointment.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      appointment.status.label,
                      style: TextStyle(
                        color: _getStatusColor(appointment.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    appointment.formattedTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.clientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          appointment.serviceName,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'R\$ ${appointment.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum agendamento',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // TODO: Implementar dialog de filtros avançados
  }

  void _showAppointmentDetails(Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildAppointmentDetailsSheet(appointment),
    );
  }

  Widget _buildAppointmentDetailsSheet(Appointment appointment) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                'Detalhes do Agendamento',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Cliente', appointment.clientName, Icons.person),
              _buildDetailRow('Serviço', appointment.serviceName, Icons.content_cut),
              _buildDetailRow('Data', appointment.formattedDate, Icons.calendar_today),
              _buildDetailRow('Horário', appointment.formattedTime, Icons.access_time),
              _buildDetailRow('Duração', '${appointment.durationMinutes} min', Icons.timer),
              _buildDetailRow('Valor', 'R\$ ${appointment.price.toStringAsFixed(2)}', Icons.attach_money),
              _buildDetailRow('Status', appointment.status.label, Icons.info),
              
              if (appointment.notes != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Observações',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(appointment.notes!),
              ],

              const SizedBox(height: 24),
              
              // Botões de ação
              if (appointment.canBeConfirmed)
                ElevatedButton(
                  onPressed: () => _confirmAppointment(appointment.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Confirmar Agendamento'),
                ),
              
              if (appointment.canBeStarted) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _startAppointment(appointment.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Iniciar Atendimento'),
                ),
              ],
              
              if (appointment.canBeCompleted) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _completeAppointment(appointment.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Concluir Atendimento'),
                ),
              ],
              
              if (appointment.canBeCancelled) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _cancelAppointment(appointment.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Cancelar Agendamento'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateDayStats(List<Appointment> appointments) {
    int total = appointments.length;
    double hours = appointments.fold(0, (sum, app) => sum + app.durationMinutes) / 60;
    double revenue = appointments
        .where((app) => app.status == AppointmentStatus.completed)
        .fold(0, (sum, app) => sum + app.price);

    return {
      'total': total,
      'hours': hours.toStringAsFixed(1),
      'revenue': revenue,
    };
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return AppColors.warning;
      case AppointmentStatus.confirmed:
        return AppColors.info;
      case AppointmentStatus.inProgress:
        return AppColors.primary;
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.cancelled:
        return AppColors.error;
      case AppointmentStatus.noShow:
        return AppColors.textSecondary;
    }
  }

  Future<void> _confirmAppointment(String id) async {
    try {
      await _appointmentService.confirmAppointment(id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agendamento confirmado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  Future<void> _startAppointment(String id) async {
    try {
      await _appointmentService.startAppointment(id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Atendimento iniciado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  Future<void> _completeAppointment(String id) async {
    try {
      await _appointmentService.completeAppointment(id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Atendimento concluído')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  Future<void> _cancelAppointment(String id) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Motivo do cancelamento',
            hintText: 'Digite o motivo...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelado pelo barbeiro'),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (reason == null) return;

    try {
      await _appointmentService.cancelAppointment(id, reason);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agendamento cancelado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }
}
