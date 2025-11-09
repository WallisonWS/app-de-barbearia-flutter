import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Barbearia
class Barbershop {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final Address address;
  final Contact contact;
  final Map<String, String> hours;
  final double rating;
  final int reviewCount;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Barbershop({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.address,
    required this.contact,
    required this.hours,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Barbershop.fromMap(Map<String, dynamic> map) {
    return Barbershop(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      ownerId: map['ownerId'] as String,
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
      contact: Contact.fromMap(map['contact'] as Map<String, dynamic>),
      hours: Map<String, String>.from(map['hours'] as Map),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
      photoUrl: map['photoUrl'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'address': address.toMap(),
      'contact': contact.toMap(),
      'hours': hours,
      'rating': rating,
      'reviewCount': reviewCount,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Barbershop copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    Address? address,
    Contact? contact,
    Map<String, String>? hours,
    double? rating,
    int? reviewCount,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Barbershop(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      hours: hours ?? this.hours,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Modelo de Endereço
class Address {
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;

  Address({
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] as String,
      number: map['number'] as String,
      complement: map['complement'] as String?,
      neighborhood: map['neighborhood'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zipCode: map['zipCode'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'number': number,
      if (complement != null) 'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }

  String get fullAddress {
    final complementText = complement != null && complement!.isNotEmpty
        ? ', $complement'
        : '';
    return '$street, $number$complementText - $neighborhood, $city - $state, $zipCode';
  }
}

/// Modelo de Contato
class Contact {
  final String phone;
  final String email;
  final String? whatsapp;

  Contact({
    required this.phone,
    required this.email,
    this.whatsapp,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      phone: map['phone'] as String,
      email: map['email'] as String,
      whatsapp: map['whatsapp'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      if (whatsapp != null) 'whatsapp': whatsapp,
    };
  }
}
