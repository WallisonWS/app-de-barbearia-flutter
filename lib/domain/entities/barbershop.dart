import 'package:equatable/equatable.dart';

class Barbershop extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? logoUrl;
  final List<String> photoUrls;
  final Address address;
  final String phone;
  final Map<String, String> socialMedia;
  final WorkingHours workingHours;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final bool isApproved;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Barbershop({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    this.photoUrls = const [],
    required this.address,
    required this.phone,
    this.socialMedia = const {},
    required this.workingHours,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    this.isApproved = false,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        logoUrl,
        photoUrls,
        address,
        phone,
        socialMedia,
        workingHours,
        rating,
        reviewCount,
        isActive,
        isApproved,
        ownerId,
        createdAt,
        updatedAt,
      ];

  Barbershop copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    List<String>? photoUrls,
    Address? address,
    String? phone,
    Map<String, String>? socialMedia,
    WorkingHours? workingHours,
    double? rating,
    int? reviewCount,
    bool? isActive,
    bool? isApproved,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Barbershop(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      photoUrls: photoUrls ?? this.photoUrls,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      socialMedia: socialMedia ?? this.socialMedia,
      workingHours: workingHours ?? this.workingHours,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      isApproved: isApproved ?? this.isApproved,
      ownerId: ownerId ?? this.ownerId,
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
    final comp = complement != null && complement!.isNotEmpty ? ', $complement' : '';
    return '$street, $number$comp - $neighborhood, $city - $state, $zipCode';
  }
}

class WorkingHours extends Equatable {
  final Map<String, DaySchedule> schedule;

  const WorkingHours({required this.schedule});

  @override
  List<Object?> get props => [schedule];

  DaySchedule? getScheduleForDay(String day) {
    return schedule[day.toLowerCase()];
  }

  bool isOpenOnDay(String day) {
    final daySchedule = getScheduleForDay(day);
    return daySchedule?.isOpen ?? false;
  }
}

class DaySchedule extends Equatable {
  final bool isOpen;
  final String? openTime;
  final String? closeTime;
  final List<TimeBlock> breaks;

  const DaySchedule({
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.breaks = const [],
  });

  @override
  List<Object?> get props => [isOpen, openTime, closeTime, breaks];
}

class TimeBlock extends Equatable {
  final String startTime;
  final String endTime;

  const TimeBlock({
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [startTime, endTime];
}
