import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String barberId;
  final String name;
  final String description;
  final double price;
  final int duration; // in minutes
  final bool active;
  final String? imageUrl;
  final DateTime createdAt;

  const Service({
    required this.id,
    required this.barberId,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.active,
    this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        barberId,
        name,
        description,
        price,
        duration,
        active,
        imageUrl,
        createdAt,
      ];

  Service copyWith({
    String? id,
    String? barberId,
    String? name,
    String? description,
    double? price,
    int? duration,
    bool? active,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Service(
      id: id ?? this.id,
      barberId: barberId ?? this.barberId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      active: active ?? this.active,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
