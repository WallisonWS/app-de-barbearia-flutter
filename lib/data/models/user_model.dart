import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de usuário do aplicativo
/// Representa todos os tipos de usuário: admin, barbershop, barber, client
class User {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String role; // 'admin', 'barbershop', 'barber', 'client'
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Campos opcionais específicos por tipo
  final String? barbershopId; // Para barbeiros
  final Map<String, dynamic>? metadata; // Dados extras

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.barbershopId,
    this.metadata,
  });

  /// Verificações de tipo de usuário
  bool get isAdmin => role == 'admin';
  bool get isBarbershop => role == 'barbershop';
  bool get isBarber => role == 'barber';
  bool get isClient => role == 'client';

  /// Criar User a partir de Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String,
      photoUrl: map['photoUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      barbershopId: map['barbershopId'] as String?,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converter User para Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (barbershopId != null) 'barbershopId': barbershopId,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Criar cópia com alterações
  User copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? role,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? barbershopId,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      barbershopId: barbershopId ?? this.barbershopId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
