import 'package:cloud_firestore/cloud_firestore.dart';

/// Status do agendamento
enum AppointmentStatus {
  pending,    // Aguardando confirmação
  confirmed,  // Confirmado
  inProgress, // Em andamento
  completed,  // Concluído
  cancelled,  // Cancelado
  noShow,     // Cliente não compareceu
}

/// Modelo de Agendamento
class Appointment {
  final String id;
  final String barbershopId;
  final String barberId;
  final String clientId;
  final String serviceId;
  final DateTime dateTime;
  final int durationMinutes;
  final double price;
  final AppointmentStatus status;
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Dados desnormalizados para performance
  final String barbershopName;
  final String barberName;
  final String clientName;
  final String serviceName;

  Appointment({
    required this.id,
    required this.barbershopId,
    required this.barberId,
    required this.clientId,
    required this.serviceId,
    required this.dateTime,
    required this.durationMinutes,
    required this.price,
    required this.status,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    required this.barbershopName,
    required this.barberName,
    required this.clientName,
    required this.serviceName,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as String,
      barbershopId: map['barbershopId'] as String,
      barberId: map['barberId'] as String,
      clientId: map['clientId'] as String,
      serviceId: map['serviceId'] as String,
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      durationMinutes: map['durationMinutes'] as int,
      price: (map['price'] as num).toDouble(),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      notes: map['notes'] as String?,
      cancellationReason: map['cancellationReason'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      barbershopName: map['barbershopName'] as String,
      barberName: map['barberName'] as String,
      clientName: map['clientName'] as String,
      serviceName: map['serviceName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'barbershopId': barbershopId,
      'barberId': barberId,
      'clientId': clientId,
      'serviceId': serviceId,
      'dateTime': Timestamp.fromDate(dateTime),
      'durationMinutes': durationMinutes,
      'price': price,
      'status': status.name,
      if (notes != null) 'notes': notes,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'barbershopName': barbershopName,
      'barberName': barberName,
      'clientName': clientName,
      'serviceName': serviceName,
    };
  }

  Appointment copyWith({
    String? id,
    String? barbershopId,
    String? barberId,
    String? clientId,
    String? serviceId,
    DateTime? dateTime,
    int? durationMinutes,
    double? price,
    AppointmentStatus? status,
    String? notes,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? barbershopName,
    String? barberName,
    String? clientName,
    String? serviceName,
  }) {
    return Appointment(
      id: id ?? this.id,
      barbershopId: barbershopId ?? this.barbershopId,
      barberId: barberId ?? this.barberId,
      clientId: clientId ?? this.clientId,
      serviceId: serviceId ?? this.serviceId,
      dateTime: dateTime ?? this.dateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      price: price ?? this.price,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      barbershopName: barbershopName ?? this.barbershopName,
      barberName: barberName ?? this.barberName,
      clientName: clientName ?? this.clientName,
      serviceName: serviceName ?? this.serviceName,
    );
  }

  /// Verificar se o agendamento está no passado
  bool get isPast => dateTime.isBefore(DateTime.now());

  /// Verificar se o agendamento está no futuro
  bool get isFuture => dateTime.isAfter(DateTime.now());

  /// Verificar se o agendamento é hoje
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// Verificar se pode ser cancelado
  bool get canBeCancelled {
    return status == AppointmentStatus.pending ||
        status == AppointmentStatus.confirmed;
  }

  /// Verificar se pode ser confirmado
  bool get canBeConfirmed {
    return status == AppointmentStatus.pending;
  }

  /// Verificar se pode ser iniciado
  bool get canBeStarted {
    return status == AppointmentStatus.confirmed && isToday;
  }

  /// Verificar se pode ser completado
  bool get canBeCompleted {
    return status == AppointmentStatus.inProgress;
  }

  /// Horário de término
  DateTime get endTime {
    return dateTime.add(Duration(minutes: durationMinutes));
  }

  /// Formatar horário
  String get formattedTime {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Formatar data
  String get formattedDate {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$day/$month/$year';
  }

  /// Formatar data e hora
  String get formattedDateTime {
    return '$formattedDate às $formattedTime';
  }
}

/// Extensão para converter string em AppointmentStatus
extension AppointmentStatusExtension on String {
  AppointmentStatus toAppointmentStatus() {
    return AppointmentStatus.values.firstWhere(
      (e) => e.name == this,
      orElse: () => AppointmentStatus.pending,
    );
  }
}

/// Extensão para obter label do status
extension AppointmentStatusLabel on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pendente';
      case AppointmentStatus.confirmed:
        return 'Confirmado';
      case AppointmentStatus.inProgress:
        return 'Em Andamento';
      case AppointmentStatus.completed:
        return 'Concluído';
      case AppointmentStatus.cancelled:
        return 'Cancelado';
      case AppointmentStatus.noShow:
        return 'Não Compareceu';
    }
  }
}
