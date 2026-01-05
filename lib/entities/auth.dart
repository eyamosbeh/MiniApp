/// Auth entity - User authentication model
class Auth {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? specialty;
  final String? classe;
  final String? subClasse;
  final bool rememberMe;
  final DateTime createdAt;

  Auth({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.specialty,
    this.classe,
    this.subClasse,
    this.rememberMe = false,
    required this.createdAt,
  });

  // Factory constructor from JSON
  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: json['id'] as int?,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      specialty: json['specialty'] as String?,
      classe: json['classe'] as String?,
      subClasse: json['subClasse'] as String?,
      rememberMe: json['rememberMe'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'specialty': specialty,
      'classe': classe,
      'subClasse': subClasse,
      'rememberMe': rememberMe,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Factory constructor from database map
  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      specialty: map['specialty'] as String?,
      classe: map['classe'] as String?,
      subClasse: map['subClasse'] as String?,
      rememberMe: map['rememberMe'] == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'specialty': specialty,
      'classe': classe,
      'subClasse': subClasse,
      'rememberMe': rememberMe ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // CopyWith method for immutability
  Auth copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? specialty,
    String? classe,
    String? subClasse,
    bool? rememberMe,
    DateTime? createdAt,
  }) {
    return Auth(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      specialty: specialty ?? this.specialty,
      classe: classe ?? this.classe,
      subClasse: subClasse ?? this.subClasse,
      rememberMe: rememberMe ?? this.rememberMe,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Auth(id: $id, username: $username, email: $email, specialty: $specialty, classe: $classe, subClasse: $subClasse)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Auth &&
        other.id == id &&
        other.username == username &&
        other.email == email;
  }

  @override
  int get hashCode {
    return Object.hash(id, username, email);
  }
}

