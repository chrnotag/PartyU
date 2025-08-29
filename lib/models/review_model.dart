import 'dart:convert';

class Review {
  final String id;
  final String venueId;
  final String userId;
  final String userName;
  final int rating;
  final String? comment;
  final List<String> images;
  final int likes;
  final int dislikes;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.venueId,
    required this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    this.images = const [],
    this.likes = 0,
    this.dislikes = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'venueId': venueId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'images': jsonEncode(images),
      'likes': likes,
      'dislikes': dislikes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    List<String> imageList = [];
    if (map['images'] != null) {
      try {
        imageList = List<String>.from(jsonDecode(map['images']));
      } catch (e) {
        imageList = [];
      }
    }

    return Review(
      id: map['id'],
      venueId: map['venueId'],
      userId: map['userId'],
      userName: map['userName'],
      rating: map['rating'],
      comment: map['comment'],
      images: imageList,
      likes: map['likes'] ?? 0,
      dislikes: map['dislikes'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Review copyWith({
    String? id,
    String? venueId,
    String? userId,
    String? userName,
    int? rating,
    String? comment,
    List<String>? images,
    int? likes,
    int? dislikes,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}