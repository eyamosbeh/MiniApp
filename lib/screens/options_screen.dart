import 'package:flutter/material.dart';
import 'option_detail_screen.dart';
import '../widgets/app_bottom_nav.dart';

/// Options screen showing list of subjects/modules for a specialty
class OptionsScreen extends StatelessWidget {
  final String specialty;

  const OptionsScreen({
    super.key,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    // Get options based on specialty
    final options = _getOptionsForSpecialty(specialty);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Liste des Options',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFCC0000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return _buildOptionCard(
            context,
            code: option['code'] as String,
            title: option['title'] as String,
            icon: option['icon'] as String,
            color: option['color'] as Color,
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String code,
    required String title,
    required String icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OptionDetailScreen(
                  code: code,
                  title: title,
                  color: color,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon/Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getOptionsForSpecialty(String specialty) {
    switch (specialty) {
      case 'Informatique':
        return [
          {
            'code': 'ERP/BI',
            'title': 'Enterprise Resource Planning - Business Intelligence',
            'icon': '👥',
            'color': const Color(0xFFE91E63),
          },
          {
            'code': 'ArcTic',
            'title': 'Architecture IT & Cloud Computing',
            'icon': '💻',
            'color': const Color(0xFF2196F3),
          },
          {
            'code': 'SIM',
            'title': 'Système d\'information et mobile',
            'icon': '📱',
            'color': const Color(0xFFFF9800),
          },
          {
            'code': 'DS',
            'title': 'Data Science',
            'icon': '📊',
            'color': const Color(0xFF9C27B0),
          },
          {
            'code': 'IA',
            'title': 'Intelligence Artificielle',
            'icon': '🤖',
            'color': const Color(0xFF00BCD4),
          },
          {
            'code': 'SE',
            'title': 'Software Engineering',
            'icon': '⚙️',
            'color': const Color(0xFF4CAF50),
          },
          {
            'code': 'NIDS',
            'title': 'Nouvelles technologies de l\'internet, Image et Données Scientifiques',
            'icon': '🌐',
            'color': const Color(0xFF673AB7),
          },
        ];
      case 'Télécommunications':
        return [
          {
            'code': 'RT',
            'title': 'Réseaux et Télécommunications',
            'icon': '📡',
            'color': const Color(0xFF4CAF50),
          },
          {
            'code': 'SEC',
            'title': 'Sécurité des Réseaux',
            'icon': '🔒',
            'color': const Color(0xFFF44336),
          },
          {
            'code': 'IOT',
            'title': 'Internet des Objets',
            'icon': '🌐',
            'color': const Color(0xFF2196F3),
          },
        ];
      case 'Génie civil':
        return [
          {
            'code': 'GC',
            'title': 'Génie Civil',
            'icon': '🏗️',
            'color': const Color(0xFFFF9800),
          },
          {
            'code': 'BTP',
            'title': 'Bâtiment et Travaux Publics',
            'icon': '🏢',
            'color': const Color(0xFF795548),
          },
        ];
      case 'Électromécanique':
        return [
          {
            'code': 'EM',
            'title': 'Électromécanique',
            'icon': '⚙️',
            'color': const Color(0xFF607D8B),
          },
          {
            'code': 'AUTO',
            'title': 'Automatique',
            'icon': '🤖',
            'color': const Color(0xFF9E9E9E),
          },
        ];
      default:
        return [
          {
            'code': 'GEN',
            'title': 'Option générale',
            'icon': '📚',
            'color': const Color(0xFF9C27B0),
          },
        ];
    }
  }
}

