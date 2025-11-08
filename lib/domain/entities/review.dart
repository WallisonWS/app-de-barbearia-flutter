import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String clientId;
  final String clientName;
  final String? clientPhotoUrl;
  final String barbershopId;
  final String? barberId;
  final String? barberName;
  final String appointmentId;
  final double rating;
  final String comment;
  final List<String> photoUrls;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.clientPhotoUrl,
    required this.barbershopId,
    this.barberId,
    this.barberName,
    required this.appointmentId,
    required this.rating,
    required this.comment,
    this.photoUrls = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        clientId,
        clientName,
        clientPhotoUrl,
        barbershopId,
        barberId,
        barberName,
        appointmentId,
        rating,
        comment,
        photoUrls,
        createdAt,
      ];

  Review copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? clientPhotoUrl,
    String? barbershopId,
    String? barberId,
    String? barberName,
    String? appointmentId,
    double? rating,
    String? comment,
    List<String>? photoUrls,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhotoUrl: clientPhotoUrl ?? this.clientPhotoUrl,
      barbershopId: barbershopId ?? this.barbershopId,
      barberId: barberId ?? this.barberId,
      barberName: barberName ?? this.barberName,
      appointmentId: appointmentId ?? this.appointmentId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
