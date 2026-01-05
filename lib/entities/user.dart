/// User entity - Pure data model
class User {
  final int? id;
  final String name;
  final String email;
  final DateTime createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  // Factory constructor from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Factory constructor from database map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // CopyWith method for immutability
  User copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, email, createdAt);
  }
}

