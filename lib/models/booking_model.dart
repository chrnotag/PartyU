import 'dart:convert';

import 'venue_model.dart';

class Booking {
  final String id;
  final String venueId;
  final String venueName;
  final String userId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int duration;
  final double totalPrice;
  final int depositPercentage;
  final Service service;
  final int? numberOfPeople;
  final String status;
  final bool depositPaid;
  final double? depositAmount;
  final String? category;
  final bool isFromGuide;
  final DateTime createdAt;
  final DateTime? responseDeadline;

  Booking({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalPrice,
    required this.depositPercentage,
    required this.service,
    this.numberOfPeople,
    this.status = 'Pendente',
    this.depositPaid = false,
    this.depositAmount,
    this.category,
    this.isFromGuide = false,
    required this.createdAt,
    this.responseDeadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'venueId': venueId,
      'venueName': venueName,
      'userId': userId,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
      'totalPrice': totalPrice,
      'depositPercentage': depositPercentage,
      'serviceData': jsonEncode(service.toMap()),
      'numberOfPeople': numberOfPeople,
      'status': status,
      'depositPaid': depositPaid ? 1 : 0,
      'depositAmount': depositAmount,
      'category': category,
      'isFromGuide': isFromGuide ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'responseDeadline': responseDeadline?.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    Service service;
    try {
      service = Service.fromMap(jsonDecode(map['serviceData']));
    } catch (e) {
      service = Service(
        id: '1',
        name: 'Serviço Padrão',
        description: '',
        pricingType: 'fixed',
        price: 0,
        depositPercentage: 10,
        includes: [],
      );
    }

    return Booking(
      id: map['id'],
      venueId: map['venueId'],
      venueName: map['venueName'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      startTime: map['startTime'],
      endTime: map['endTime'],
      duration: map['duration'],
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      depositPercentage: map['depositPercentage'] ?? 10,
      service: service,
      numberOfPeople: map['numberOfPeople'],
      status: map['status'] ?? 'Pendente',
      depositPaid: map['depositPaid'] == 1,
      depositAmount: map['depositAmount']?.toDouble(),
      category: map['category'],
      isFromGuide: map['isFromGuide'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      responseDeadline:
          map['responseDeadline'] != null
              ? DateTime.parse(map['responseDeadline'])
              : null,
    );
  }

  Booking copyWith({
    String? id,
    String? venueId,
    String? venueName,
    String? userId,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? duration,
    double? totalPrice,
    int? depositPercentage,
    Service? service,
    int? numberOfPeople,
    String? status,
    bool? depositPaid,
    double? depositAmount,
    String? category,
    bool? isFromGuide,
    DateTime? createdAt,
    DateTime? responseDeadline,
  }) {
    return Booking(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      totalPrice: totalPrice ?? this.totalPrice,
      depositPercentage: depositPercentage ?? this.depositPercentage,
      service: service ?? this.service,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      status: status ?? this.status,
      depositPaid: depositPaid ?? this.depositPaid,
      depositAmount: depositAmount ?? this.depositAmount,
      category: category ?? this.category,
      isFromGuide: isFromGuide ?? this.isFromGuide,
      createdAt: createdAt ?? this.createdAt,
      responseDeadline: responseDeadline ?? this.responseDeadline,
    );
  }
}
