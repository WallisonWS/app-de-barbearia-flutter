import 'package:equatable/equatable.dart';

enum AppointmentStatus { scheduled, confirmed, completed, cancelled }

class Appointment extends Equatable {
  final String id;
  final String barberId;
  final String clientId;
  final String serviceId;
  final DateTime scheduledAt;
  final int duration; // in minutes
  final AppointmentStatus status;
  final double price;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    required this.id,
    required this.barberId,
    required this.clientId,
    required this.serviceId,
    required this.scheduledAt,
    required this.duration,
    required this.status,
    required this.price,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        barberId,
        clientId,
        serviceId,
        scheduledAt,
        duration,
        status,
        price,
        notes,
        createdAt,
        updatedAt,
      ];

  Appointment copyWith({
    String? id,
    String? barberId,
    String? clientId,
    String? serviceId,
    DateTime? scheduledAt,
    int? duration,
    AppointmentStatus? status,
    double? price,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      barberId: barberId ?? this.barberId,
      clientId: clientId ?? this.clientId,
      serviceId: serviceId ?? this.serviceId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DateTime get endTime => scheduledAt.add(Duration(minutes: duration));

  bool get isPast => DateTime.now().isAfter(scheduledAt);

  bool get isToday {
    final now = DateTime.now();
    return scheduledAt.year == now.year &&
        scheduledAt.month == now.month &&
        scheduledAt.day == now.day;
  }
}
