import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/specialties_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider pour gérer plusieurs providers
    return MultiProvider(
      providers: [
        // ThemeProvider - État global du thème
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // AuthProvider - Gestion de l'authentification
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // UserProvider - Gestion des utilisateurs
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ProductProvider - Gestion des produits
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ESPRIT - Revision App',
            debugShowCheckedModeBanner: false,
            // Thème configuré via Provider
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthCheckScreen(),
          );
        },
      ),
    );
  }
}

/// Splash screen that checks for remembered user
class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkRememberedUser();

    if (mounted) {
      // Navigate based on auth state
      if (authProvider.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SpecialtiesScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCC0000),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'ESPRIT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

