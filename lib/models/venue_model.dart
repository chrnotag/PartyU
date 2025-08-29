import 'dart:convert';

class Service {
  final String id;
  final String name;
  final String description;
  final String pricingType;
  final double price;
  final int? minHours;
  final int? maxHours;
  final int? minPeople;
  final int? maxPeople;
  final int depositPercentage;
  final int? duration;
  final List<String> includes;
  final bool popular;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.pricingType,
    required this.price,
    this.minHours,
    this.maxHours,
    this.minPeople,
    this.maxPeople,
    required this.depositPercentage,
    this.duration,
    required this.includes,
    this.popular = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pricingType': pricingType,
      'price': price,
      'minHours': minHours,
      'maxHours': maxHours,
      'minPeople': minPeople,
      'maxPeople': maxPeople,
      'depositPercentage': depositPercentage,
      'duration': duration,
      'includes': includes,
      'popular': popular,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      pricingType: map['pricingType'] ?? 'fixed',
      price: (map['price'] ?? 0).toDouble(),
      minHours: map['minHours'],
      maxHours: map['maxHours'],
      minPeople: map['minPeople'],
      maxPeople: map['maxPeople'],
      depositPercentage: map['depositPercentage'] ?? 10,
      duration: map['duration'],
      includes: List<String>.from(map['includes'] ?? []),
      popular: map['popular'] ?? false,
    );
  }
}

class Venue {
  final String id;
  final String name;
  final String category;
  final String? description;
  final double rating;
  final String? price;
  final String? period;
  final String? distance;
  final String? address;
  final List<String> images;
  final List<Service> services;
  final String? ownerId;
  final DateTime createdAt;

  Venue({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.rating = 0.0,
    this.price,
    this.period,
    this.distance,
    this.address,
    this.images = const [],
    this.services = const [],
    this.ownerId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'rating': rating,
      'price': price,
      'period': period,
      'distance': distance,
      'address': address,
      'images': jsonEncode(images),
      'services': jsonEncode(services.map((s) => s.toMap()).toList()),
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Venue.fromMap(Map<String, dynamic> map) {
    List<String> imageList = [];
    if (map['images'] != null) {
      try {
        imageList = List<String>.from(jsonDecode(map['images']));
      } catch (e) {
        imageList = [];
      }
    }

    List<Service> serviceList = [];
    if (map['services'] != null) {
      try {
        final servicesJson = jsonDecode(map['services']) as List;
        serviceList = servicesJson.map((s) => Service.fromMap(s)).toList();
      } catch (e) {
        serviceList = [];
      }
    }

    return Venue(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      price: map['price'],
      period: map['period'],
      distance: map['distance'],
      address: map['address'],
      images: imageList,
      services: serviceList,
      ownerId: map['ownerId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Venue copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    double? rating,
    String? price,
    String? period,
    String? distance,
    String? address,
    List<String>? images,
    List<Service>? services,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return Venue(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      period: period ?? this.period,
      distance: distance ?? this.distance,
      address: address ?? this.address,
      images: images ?? this.images,
      services: services ?? this.services,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}