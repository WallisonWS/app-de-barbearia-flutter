import 'package:equatable/equatable.dart';

enum SubscriptionStatus { active, inactive, suspended, pending }

class Barber extends Equatable {
  final String id;
  final String userId;
  final String businessName;
  final String description;
  final Address address;
  final Map<String, WorkingHours> workingHours;
  final SubscriptionStatus subscriptionStatus;
  final DateTime? subscriptionExpiresAt;
  final int totalClients;
  final double rating;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Barber({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.description,
    required this.address,
    required this.workingHours,
    required this.subscriptionStatus,
    this.subscriptionExpiresAt,
    required this.totalClients,
    required this.rating,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        businessName,
        description,
        address,
        workingHours,
        subscriptionStatus,
        subscriptionExpiresAt,
        totalClients,
        rating,
        photoUrl,
        createdAt,
        updatedAt,
      ];

  Barber copyWith({
    String? id,
    String? userId,
    String? businessName,
    String? description,
    Address? address,
    Map<String, WorkingHours>? workingHours,
    SubscriptionStatus? subscriptionStatus,
    DateTime? subscriptionExpiresAt,
    int? totalClients,
    double? rating,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Barber(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessName: businessName ?? this.businessName,
      description: description ?? this.description,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      totalClients: totalClients ?? this.totalClients,
      rating: rating ?? this.rating,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Address extends Equatable {
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final double? latitude;
  final double? longitude;

  const Address({
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        street,
        number,
        complement,
        neighborhood,
        city,
        state,
        zipCode,
        latitude,
        longitude,
      ];

  String get fullAddress {
    final complementStr = complement != null ? ', $complement' : '';
    return '$street, $number$complementStr - $neighborhood, $city - $state, $zipCode';
  }
}

class WorkingHours extends Equatable {
  final bool isOpen;
  final String? openTime;
  final String? closeTime;

  const WorkingHours({
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  @override
  List<Object?> get props => [isOpen, openTime, closeTime];
}
