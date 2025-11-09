import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

/// Serviço Firestore para gerenciar agendamentos
/// HIERARQUIA:
/// - Admin: pode ver e gerenciar todos os agendamentos
/// - Barbearia: pode ver agendamentos da sua barbearia
/// - Barbeiro: pode ver seus próprios agendamentos
/// - Cliente: pode ver seus próprios agendamentos
class FirestoreAppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'appointments';

  // ==================== CREATE ====================

  /// Criar novo agendamento
  Future<String> createAppointment(Appointment appointment) async {
    try {
      // Verificar se o horário está disponível
      final isAvailable = await isTimeSlotAvailable(
        appointment.barberId,
        appointment.dateTime,
        appointment.durationMinutes,
      );

      if (!isAvailable) {
        throw Exception('Horário não disponível');
      }

      final docRef = await _firestore.collection(_collection).add(appointment.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao criar agendamento: $e');
    }
  }

  // ==================== READ ====================

  /// Buscar agendamento por ID
  Future<Appointment?> getAppointmentById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      
      if (!doc.exists) {
        return null;
      }

      return Appointment.fromMap({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Erro ao buscar agendamento: $e');
    }
  }

  /// Stream de um agendamento
  Stream<Appointment?> getAppointmentStream(String id) {
    return _firestore.collection(_collection).doc(id).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      return Appointment.fromMap({...doc.data()!, 'id': doc.id});
    });
  }

  /// Listar agendamentos do cliente
  Future<List<Appointment>> getClientAppointments(String clientId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('clientId', isEqualTo: clientId)
          .orderBy('dateTime', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar agendamentos do cliente: $e');
    }
  }

  /// Stream de agendamentos do cliente
  Stream<List<Appointment>> getClientAppointmentsStream(String clientId) {
    return _firestore
        .collection(_collection)
        .where('clientId', isEqualTo: clientId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  /// Listar agendamentos do barbeiro
  Future<List<Appointment>> getBarberAppointments(String barberId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('barberId', isEqualTo: barberId)
          .orderBy('dateTime', descending: false)
          .get();
      
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar agendamentos do barbeiro: $e');
    }
  }

  /// Stream de agendamentos do barbeiro
  Stream<List<Appointment>> getBarberAppointmentsStream(String barberId) {
    return _firestore
        .collection(_collection)
        .where('barberId', isEqualTo: barberId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  /// Listar agendamentos da barbearia
  Future<List<Appointment>> getBarbershopAppointments(String barbershopId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('barbershopId', isEqualTo: barbershopId)
          .orderBy('dateTime', descending: false)
          .get();
      
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar agendamentos da barbearia: $e');
    }
  }

  /// Stream de agendamentos da barbearia
  Stream<List<Appointment>> getBarbershopAppointmentsStream(String barbershopId) {
    return _firestore
        .collection(_collection)
        .where('barbershopId', isEqualTo: barbershopId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  /// Listar agendamentos por data
  Future<List<Appointment>> getAppointmentsByDate(
    String barberId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await _firestore
          .collection(_collection)
          .where('barberId', isEqualTo: barberId)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('dateTime')
          .get();
      
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar agendamentos por data: $e');
    }
  }

  /// Listar agendamentos por período
  Future<List<Appointment>> getAppointmentsByPeriod(
    String barberId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('barberId', isEqualTo: barberId)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('dateTime')
          .get();
      
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar agendamentos por período: $e');
    }
  }

  /// Listar agendamentos por status
  Future<List<Appointment>> getAppointmentsByStatus(
    String barberId,
    AppointmentStatus status,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('barberId', isEqualTo: barberId)
          .where('status', isEqualTo: status.name)
          .orderBy('dateTime')
          .get();
      
      return snapshot.docs
          .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar agendamentos por status: $e');
    }
  }

  // ==================== UPDATE ====================

  /// Atualizar agendamento
  Future<void> updateAppointment(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar agendamento: $e');
    }
  }

  /// Confirmar agendamento
  Future<void> confirmAppointment(String id) async {
    try {
      await updateAppointment(id, {
        'status': AppointmentStatus.confirmed.name,
      });
    } catch (e) {
      throw Exception('Erro ao confirmar agendamento: $e');
    }
  }

  /// Iniciar agendamento
  Future<void> startAppointment(String id) async {
    try {
      await updateAppointment(id, {
        'status': AppointmentStatus.inProgress.name,
      });
    } catch (e) {
      throw Exception('Erro ao iniciar agendamento: $e');
    }
  }

  /// Completar agendamento
  Future<void> completeAppointment(String id) async {
    try {
      await updateAppointment(id, {
        'status': AppointmentStatus.completed.name,
      });
    } catch (e) {
      throw Exception('Erro ao completar agendamento: $e');
    }
  }

  /// Cancelar agendamento
  Future<void> cancelAppointment(String id, String reason) async {
    try {
      await updateAppointment(id, {
        'status': AppointmentStatus.cancelled.name,
        'cancellationReason': reason,
      });
    } catch (e) {
      throw Exception('Erro ao cancelar agendamento: $e');
    }
  }

  /// Marcar como não compareceu
  Future<void> markAsNoShow(String id) async {
    try {
      await updateAppointment(id, {
        'status': AppointmentStatus.noShow.name,
      });
    } catch (e) {
      throw Exception('Erro ao marcar como não compareceu: $e');
    }
  }

  // ==================== DELETE ====================

  /// Deletar agendamento
  Future<void> deleteAppointment(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar agendamento: $e');
    }
  }

  // ==================== DISPONIBILIDADE ====================

  /// Verificar se horário está disponível
  Future<bool> isTimeSlotAvailable(
    String barberId,
    DateTime dateTime,
    int durationMinutes,
  ) async {
    try {
      final endTime = dateTime.add(Duration(minutes: durationMinutes));

      // Buscar agendamentos que possam conflitar
      final snapshot = await _firestore
          .collection(_collection)
          .where('barberId', isEqualTo: barberId)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(
            dateTime.subtract(const Duration(hours: 2)),
          ))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(
            dateTime.add(const Duration(hours: 2)),
          ))
          .where('status', whereIn: [
            AppointmentStatus.pending.name,
            AppointmentStatus.confirmed.name,
            AppointmentStatus.inProgress.name,
          ])
          .get();

      // Verificar conflitos
      for (final doc in snapshot.docs) {
        final appointment = Appointment.fromMap({...doc.data(), 'id': doc.id});
        final appointmentEnd = appointment.endTime;

        // Verificar se há sobreposição
        if (dateTime.isBefore(appointmentEnd) && endTime.isAfter(appointment.dateTime)) {
          return false;
        }
      }

      return true;
    } catch (e) {
      throw Exception('Erro ao verificar disponibilidade: $e');
    }
  }

  /// Obter horários disponíveis para um dia
  Future<List<DateTime>> getAvailableTimeSlots(
    String barberId,
    DateTime date,
    int durationMinutes,
  ) async {
    try {
      // Horário de funcionamento: 9h às 18h
      final List<DateTime> availableSlots = [];
      final startHour = 9;
      final endHour = 18;
      final slotInterval = 30; // Intervalo de 30 minutos

      // Gerar todos os slots possíveis
      for (int hour = startHour; hour < endHour; hour++) {
        for (int minute = 0; minute < 60; minute += slotInterval) {
          final slot = DateTime(date.year, date.month, date.day, hour, minute);
          
          // Verificar se o slot + duração não ultrapassa o horário de fechamento
          final slotEnd = slot.add(Duration(minutes: durationMinutes));
          if (slotEnd.hour >= endHour) {
            continue;
          }

          // Verificar se está disponível
          final isAvailable = await isTimeSlotAvailable(
            barberId,
            slot,
            durationMinutes,
          );

          if (isAvailable) {
            availableSlots.add(slot);
          }
        }
      }

      return availableSlots;
    } catch (e) {
      throw Exception('Erro ao obter horários disponíveis: $e');
    }
  }

  // ==================== ESTATÍSTICAS ====================

  /// Contar agendamentos por status
  Future<Map<AppointmentStatus, int>> countAppointmentsByStatus(
    String barberId,
  ) async {
    try {
      final Map<AppointmentStatus, int> counts = {};

      for (final status in AppointmentStatus.values) {
        final snapshot = await _firestore
            .collection(_collection)
            .where('barberId', isEqualTo: barberId)
            .where('status', isEqualTo: status.name)
            .count()
            .get();
        
        counts[status] = snapshot.count;
      }

      return counts;
    } catch (e) {
      throw Exception('Erro ao contar agendamentos por status: $e');
    }
  }

  /// Calcular receita total
  Future<double> calculateTotalRevenue(
    String barberId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('barberId', isEqualTo: barberId)
          .where('status', isEqualTo: AppointmentStatus.completed.name)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      double total = 0;
      for (final doc in snapshot.docs) {
        final appointment = Appointment.fromMap({...doc.data(), 'id': doc.id});
        total += appointment.price;
      }

      return total;
    } catch (e) {
      throw Exception('Erro ao calcular receita: $e');
    }
  }

  /// Contar total de agendamentos
  Future<int> countTotalAppointments(String barberId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('barberId', isEqualTo: barberId)
          .count()
          .get();
      return snapshot.count;
    } catch (e) {
      throw Exception('Erro ao contar agendamentos: $e');
    }
  }
}
