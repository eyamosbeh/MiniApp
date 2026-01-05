import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';

// Hackathon subscription manager
class HackathonManager {
  static final Set<String> _subscribedIds = {};
  static final List<Map<String, dynamic>> _allHackathons = [
    {
      'id': 'cyber-security',
      'title': 'Hackathon Cybersecurity',
      'date': '25-27 Janvier 2025',
      'icon': '💻🔒',
      'colors': [
        const Color(0xFF1E3A8A),
        const Color(0xFF3B82F6),
      ],
    },
    {
      'id': 'green-tech',
      'title': 'Hackathon Green Tech',
      'date': '2-4 Avril 2025',
      'icon': '🌱⚡',
      'colors': [
        const Color(0xFFB45309),
        const Color(0xFFF59E0B),
      ],
    },
    {
      'id': 'ia-2025',
      'title': 'Hackathon IA 2025',
      'date': '1-14 Mars 2025',
      'icon': '🤖🧠',
      'colors': [
        const Color(0xFF1E40AF),
        const Color(0xFF6366F1),
      ],
    },
    {
      'id': 'mobile-dev',
      'title': 'Hackathon Mobile Dev',
      'date': '15-17 Février 2025',
      'icon': '📱💡',
      'colors': [
        const Color(0xFF7C3AED),
        const Color(0xFFA78BFA),
      ],
    },
    {
      'id': 'blockchain',
      'title': 'Hackathon Blockchain',
      'date': '10-12 Mai 2025',
      'icon': '⛓️💎',
      'colors': [
        const Color(0xFF059669),
        const Color(0xFF10B981),
      ],
    },
    {
      'id': 'iot-smart',
      'title': 'Hackathon IoT Smart',
      'date': '20-22 Juin 2025',
      'icon': '🌐🔌',
      'colors': [
        const Color(0xFFDC2626),
        const Color(0xFFF87171),
      ],
    },
  ];

  static void subscribe(String id) {
    _subscribedIds.add(id);
  }

  static void unsubscribe(String id) {
    _subscribedIds.remove(id);
  }

  static bool isSubscribed(String id) {
    return _subscribedIds.contains(id);
  }

  static List<Map<String, dynamic>> getSubscribedHackathons() {
    return _allHackathons
        .where((h) => _subscribedIds.contains(h['id']))
        .toList();
  }

  static List<Map<String, dynamic>> getAllHackathons() {
    return List.from(_allHackathons);
  }
}

/// Hackathons screen showing upcoming hackathon events
class HackathonsScreen extends StatefulWidget {
  const HackathonsScreen({super.key});

  @override
  State<HackathonsScreen> createState() => _HackathonsScreenState();
}

class _HackathonsScreenState extends State<HackathonsScreen> {
  @override
  Widget build(BuildContext context) {
    final hackathons = HackathonManager.getAllHackathons();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Hackathons',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFCC0000),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: hackathons.length,
        itemBuilder: (context, index) {
          final hackathon = hackathons[index];
          final isSubscribed = HackathonManager.isSubscribed(hackathon['id'] as String);
          final isExpired = _isExpired(hackathon['date'] as String);

          return _buildHackathonCard(
            hackathon: hackathon,
            isSubscribed: isSubscribed,
            isExpired: isExpired,
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHackathonCard({
    required Map<String, dynamic> hackathon,
    required bool isSubscribed,
    required bool isExpired,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: hackathon['colors'] as List<Color>,
                  ),
                ),
                child: Center(
                  child: Text(
                    hackathon['icon'] as String,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Text(
                    hackathon['title'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Date
                  Text(
                    hackathon['date'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: isExpired
                          ? null
                          : () {
                              setState(() {
                                if (isSubscribed) {
                                  HackathonManager.unsubscribe(hackathon['id'] as String);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Désinscription de ${hackathon['title']}',
                                      ),
                                      backgroundColor: Colors.grey,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  HackathonManager.subscribe(hackathon['id'] as String);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Inscription réussie à ${hackathon['title']} !',
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isExpired
                            ? Colors.red
                            : (isSubscribed ? Colors.green : Colors.green),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isExpired
                            ? 'Date dépassé'
                            : (isSubscribed ? "S'inscrire" : "S'inscrire"),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isExpired(String dateStr) {
    // Parse date format "DD Month YYYY"
    try {
      final parts = dateStr.split(' ');
      if (parts.length < 3) return false;

      final day = int.parse(parts[0].replaceAll('er', '').replaceAll('eme', ''));
      final monthMap = {
        'Janvier': 1, 'Février': 2, 'Mars': 3, 'Avril': 4,
        'Mai': 5, 'Juin': 6, 'Juillet': 7, 'Août': 8,
        'Septembre': 9, 'Octobre': 10, 'Novembre': 11, 'Décembre': 12,
      };
      final month = monthMap[parts[1]] ?? 1;
      final year = int.parse(parts[2]);

      final hackathonDate = DateTime(year, month, day);
      final today = DateTime.now();

      return hackathonDate.isBefore(DateTime(today.year, today.month, today.day));
    } catch (e) {
      return false;
    }
  }
}

