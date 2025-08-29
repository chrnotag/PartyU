class User {
  final String id;
  final String email;
  final String name;
  final String password;
  final String? avatar;
  final DateTime createdAt;
  final bool isDemo;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    this.avatar,
    required this.createdAt,
    this.isDemo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'isDemo': isDemo ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      password: map['password'],
      avatar: map['avatar'],
      createdAt: DateTime.parse(map['createdAt']),
      isDemo: map['isDemo'] == 1,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? password,
    String? avatar,
    DateTime? createdAt,
    bool? isDemo,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}