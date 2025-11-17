import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, barber, client }

class User extends Equatable {
  // Campos opcionais específicos por tipo
  final String? barbershopId; // Para barbeiros
  final Map<String, dynamic>? metadata; // Dados extras
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.barbershopId,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        role,
        photoUrl,
        createdAt,
        updatedAt,
        barbershopId,
        metadata,
      ];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? barbershopId,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      barbershopId: barbershopId ?? this.barbershopId,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Verificações de tipo de usuário
  bool get isAdmin => role == UserRole.admin;
  bool get isBarber => role == UserRole.barber;
  bool get isClient => role == UserRole.client;

  /// Criar User a partir de Map (Firebase)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'] as String,
        orElse: () => UserRole.client,
      ),
      photoUrl: map['photoUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      barbershopId: map['barbershopId'] as String?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converter User para Map (Firebase)
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.toString().split('.').last,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (barbershopId != null) 'barbershopId': barbershopId,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
