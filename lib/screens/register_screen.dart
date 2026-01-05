import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'specialties_screen.dart';

/// Registration screen with specialty selection
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedSpecialty;
  bool _obscurePassword = true;

  final List<String> _specialties = [
    'Informatique',
    'Génie Civil',
    'Électromécanique',
    'Télécommunications',
    'Management',
    'Finance',
    'Architecture',
    'Design',
  ];

  // Class options that appear after specialty selection
  final Map<String, List<String>> _classOptions = {
    'Informatique': ['4SIM', '4GAMIX', '4TWIN', '4DS'],
    'Génie Civil': ['4GC1', '4GC2', '4GC3'],
    'Électromécanique': ['4EM1', '4EM2', '4EM3'],
    'Télécommunications': ['4TELEC1', '4TELEC2'],

  };

  // Sub-class options (levels within each class)
  final Map<String, List<String>> _subClassOptions = {
    '4SIM': ['4SIM1', '4SIM2', '4SIM3', '4SIM4'],
    '4GAMIX': ['4GAMIX1', '4GAMIX2'],
    '4TWIN': ['4TWIN1', '4TWIN2', '4TWIN3'],
    '4DS': ['4DS1', '4DS2'],
  };

  String? _selectedClass;
  String? _selectedSubClass;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                const Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Nom d\'utilisateur',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez saisir votre nom d\'utilisateur';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez saisir votre email';
                    }
                    if (!value.contains('@esprit.tn')) {
                      return 'Email invalide (@esprit.tn requis)';
                    }
                    return null;
                  },
                ),

                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.errorMessage != null &&
                        authProvider.errorMessage!.contains('Email')) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 24, top: 4),
                        child: Text(
                          authProvider.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Mot de Passe',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mot de passe requis';
                    }
                    if (value.length < 6) {
                      return 'Minimum 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Specialty dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedSpecialty,
                  decoration: InputDecoration(
                    hintText: 'Sélectionnez votre Spécialité',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  items: _specialties.map((specialty) {
                    return DropdownMenuItem(
                      value: specialty,
                      child: Text(specialty),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecialty = value;
                      _selectedClass = null; // Reset class when specialty changes
                      _selectedSubClass = null; // Reset subclass when specialty changes
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez choisir une spécialité';
                    }
                    return null;
                  },
                ),

                // Show class dropdown only if specialty is selected
                if (_selectedSpecialty != null && _classOptions.containsKey(_selectedSpecialty)) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 0),
                    child: Text(
                      'Veuillez choisir une spécialité',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Class dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedClass,
                    decoration: InputDecoration(
                      hintText: 'Sélectionnez votre classe ($_selectedSpecialty)',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    items: _classOptions[_selectedSpecialty]?.map((className) {
                      return DropdownMenuItem(
                        value: className,
                        child: Text(className),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClass = value;
                        _selectedSubClass = null; // Reset subclass when class changes
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez choisir une classe';
                      }
                      return null;
                    },
                  ),
                ],

                // Show subclass dropdown only if class is selected and has subclasses
                if (_selectedClass != null && _subClassOptions.containsKey(_selectedClass)) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 0),
                    child: Text(
                      'Veuillez choisir une spécialité',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SubClass dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSubClass,
                    decoration: InputDecoration(
                      hintText: 'Sélectionnez votre classe ($_selectedClass)',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    items: _subClassOptions[_selectedClass]?.map((subClassName) {
                      return DropdownMenuItem(
                        value: subClassName,
                        child: Text(subClassName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubClass = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez choisir une classe';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 32),

                // Register button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC0000),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'CRÉER UN COMPTE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Error message
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.errorMessage != null &&
                        !authProvider.errorMessage!.contains('Email invalide')) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          authProvider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    // Determine the final class value (use subclass if available, otherwise class)
    final finalClass = _selectedSubClass ?? _selectedClass;

    final success = await authProvider.register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      specialty: _selectedSpecialty,
      classe: _selectedClass,
      subClasse: finalClass,
    );

    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compte créé avec succès!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to specialties screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SpecialtiesScreen()),
      );
    }
  }
}
/// Auth entity - User authentication model
class Auth {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? specialty;
  final bool rememberMe;
  final DateTime createdAt;

  Auth({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.specialty,
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
    bool? rememberMe,
    DateTime? createdAt,
  }) {
    return Auth(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      specialty: specialty ?? this.specialty,
      rememberMe: rememberMe ?? this.rememberMe,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Auth(id: $id, username: $username, email: $email, specialty: $specialty)';
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

