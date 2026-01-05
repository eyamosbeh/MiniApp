import 'package:flutter/material.dart';
import '../screens/specialties_screen.dart';
import '../screens/hackathons_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/my_registrations_screen.dart';

/// Reusable bottom navigation bar for the app
class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFCC0000),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.code),
          label: 'Hackathon',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favoris',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Mes inscriptions',
        ),
      ],
      onTap: (index) {
        // Don't navigate if already on the current tab
        if (index == currentIndex) return;

        _navigateToScreen(context, index);
      },
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    Widget screen;

    switch (index) {
      case 0:
        screen = const SpecialtiesScreen();
        break;
      case 1:
        screen = const HackathonsScreen();
        break;
      case 2:
        screen = const FavoritesScreen();
        break;
      case 3:
        screen = const MyRegistrationsScreen();
        break;
      default:
        return;
    }

    // Use pushReplacement to avoid building up navigation stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

