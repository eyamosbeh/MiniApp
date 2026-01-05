/// Product entity - Pure data model
class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final DateTime createdAt;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.createdAt,
  });

  // Factory constructor from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Factory constructor from database map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // CopyWith method for immutability
  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, description, price, imageUrl, createdAt);
  }
}

