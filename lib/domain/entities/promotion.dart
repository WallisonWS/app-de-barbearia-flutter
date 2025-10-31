import 'package:equatable/equatable.dart';

class Promotion extends Equatable {
  final String id;
  final String barberId;
  final String title;
  final String description;
  final double discount; // percentage
  final DateTime validFrom;
  final DateTime validUntil;
  final String? imageUrl;
  final bool active;
  final DateTime createdAt;

  const Promotion({
    required this.id,
    required this.barberId,
    required this.title,
    required this.description,
    required this.discount,
    required this.validFrom,
    required this.validUntil,
    this.imageUrl,
    required this.active,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        barberId,
        title,
        description,
        discount,
        validFrom,
        validUntil,
        imageUrl,
        active,
        createdAt,
      ];

  Promotion copyWith({
    String? id,
    String? barberId,
    String? title,
    String? description,
    double? discount,
    DateTime? validFrom,
    DateTime? validUntil,
    String? imageUrl,
    bool? active,
    DateTime? createdAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      barberId: barberId ?? this.barberId,
      title: title ?? this.title,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      imageUrl: imageUrl ?? this.imageUrl,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isValid {
    final now = DateTime.now();
    return active && now.isAfter(validFrom) && now.isBefore(validUntil);
  }

  bool get isExpired => DateTime.now().isAfter(validUntil);
}
