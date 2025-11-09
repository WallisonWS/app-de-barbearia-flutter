import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/services/firestore_appointment_service.dart';
import '../../widgets/loading_button.dart';

/// Tela de agendamento com calendário
class BookingScreen extends StatefulWidget {
  final String barbershopId;
  final String barberId;
  final String serviceId;
  final String serviceName;
  final double servicePrice;
  final int serviceDuration;

  const BookingScreen({
    super.key,
    required this.barbershopId,
    required this.barberId,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceDuration,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirestoreAppointmentService _appointmentService = FirestoreAppointmentService();
  
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedTimeSlot;
  List<DateTime> _availableSlots = [];
  bool _isLoadingSlots = false;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _loadAvailableSlots(_selectedDay);
  }

  Future<void> _loadAvailableSlots(DateTime date) async {
    setState(() {
      _isLoadingSlots = true;
      _selectedTimeSlot = null;
    });

    try {
      final slots = await _appointmentService.getAvailableTimeSlots(
        widget.barberId,
        date,
        widget.serviceDuration,
      );

      setState(() {
        _availableSlots = slots;
        _isLoadingSlots = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSlots = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar horários: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um horário'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    try {
      // TODO: Obter dados reais do usuário logado
      final appointment = Appointment(
        id: '',
        barbershopId: widget.barbershopId,
        barberId: widget.barberId,
        clientId: 'current_user_id', // TODO: Substituir por ID real
        serviceId: widget.serviceId,
        dateTime: _selectedTimeSlot!,
        durationMinutes: widget.serviceDuration,
        price: widget.servicePrice,
        status: AppointmentStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        barbershopName: 'Nome da Barbearia', // TODO: Passar como parâmetro
        barberName: 'Nome do Barbeiro', // TODO: Passar como parâmetro
        clientName: 'Nome do Cliente', // TODO: Obter do usuário logado
        serviceName: widget.serviceName,
      );

      await _appointmentService.createAppointment(appointment);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agendamento realizado com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao agendar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Horário'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Informações do serviço
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.serviceName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.serviceDuration} min',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    Text(
                      'R\$ ${widget.servicePrice.toStringAsFixed(2)}',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Calendário
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 90)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _loadAvailableSlots(selectedDay);
                      },
                      calendarFormat: CalendarFormat.month,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  // Horários disponíveis
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Horários Disponíveis',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),

                        if (_isLoadingSlots)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (_availableSlots.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: 64,
                                    color: AppColors.textHint,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum horário disponível',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _availableSlots.map((slot) {
                              final isSelected = _selectedTimeSlot == slot;
                              final hour = slot.hour.toString().padLeft(2, '0');
                              final minute = slot.minute.toString().padLeft(2, '0');
                              final timeText = '$hour:$minute';

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedTimeSlot = slot;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Text(
                                    timeText,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão de confirmar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: LoadingButton(
                text: 'Confirmar Agendamento',
                onPressed: _selectedTimeSlot != null ? _confirmBooking : null,
                isLoading: _isBooking,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
