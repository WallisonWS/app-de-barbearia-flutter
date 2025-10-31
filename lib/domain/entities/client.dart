import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final String id;
  final String userId;
  final String barberId;
  final String? notes;
  final DateTime? lastVisit;
  final int totalVisits;
  final DateTime createdAt;

  const Client({
    required this.id,
    required this.userId,
    required this.barberId,
    this.notes,
    this.lastVisit,
    required this.totalVisits,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        barberId,
        notes,
        lastVisit,
        totalVisits,
        createdAt,
      ];

  Client copyWith({
    String? id,
    String? userId,
    String? barberId,
    String? notes,
    DateTime? lastVisit,
    int? totalVisits,
    DateTime? createdAt,
  }) {
    return Client(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      barberId: barberId ?? this.barberId,
      notes: notes ?? this.notes,
      lastVisit: lastVisit ?? this.lastVisit,
      totalVisits: totalVisits ?? this.totalVisits,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
