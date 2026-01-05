import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import '../widgets/app_bottom_nav.dart';

/// Option detail screen showing complete information about a selected option
class OptionDetailScreen extends StatefulWidget {
  final String code;
  final String title;
  final Color color;

  const OptionDetailScreen({
    super.key,
    required this.code,
    required this.title,
    required this.color,
  });

  @override
  State<OptionDetailScreen> createState() => _OptionDetailScreenState();
}

class _OptionDetailScreenState extends State<OptionDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoritesManager.isFavorite(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    final details = _getOptionDetails(widget.code);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.code,
          style: const TextStyle(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      details['icon'] as String,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Description section
              _buildSection(
                title: 'Description:',
                content: details['description'] as String,
              ),
              const SizedBox(height: 16),

              // Débouchés section
              _buildSection(
                title: 'Débouchés:',
                content: details['debouches'] as String,
              ),
              const SizedBox(height: 16),

              // Formula section
              _buildSection(
                title: 'Formule de calcul du score:',
                content: details['formula'] as String,
              ),
              const SizedBox(height: 24),

              // Add to favorites button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });

                  if (isFavorite) {
                    // Add to favorites
                    FavoritesManager.addFavorite({
                      'code': widget.code,
                      'title': widget.title,
                      'description': details['description'],
                      'icon': details['icon'],
                      'color': widget.color,
                    });
                  } else {
                    // Remove from favorites
                    FavoritesManager.removeFavorite(widget.code);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? '${widget.code} ajouté aux favoris'
                            : '${widget.code} retiré des favoris',
                      ),
                      backgroundColor: isFavorite ? Colors.green : Colors.grey,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC0000),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isFavorite ? 'RETIRÉ DES FAVORIS' : 'AJOUTER AUX FAVORIS',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getOptionDetails(String code) {
    final details = {
      'ERP/BI': {
        'icon': '👥⚙️',
        'description':
            'Expertise en déploiement de solutions ERP et Business Intelligence pour optimiser la gestion des entreprises.',
        'debouches':
            'Consultant ERP, Data Analyst, Expert BI, Chef de projet IT, Business Analyst.',
        'formula':
            'Note finale = (0.3 × Projet) + (0.4 × Stage) + (0.3 × Examen)',
      },
      'ArcTic': {
        'icon': '💻☁️',
        'description':
            'Formation en architecture des systèmes d\'information et solutions Cloud Computing pour la transformation digitale.',
        'debouches':
            'Architecte Cloud, DevOps Engineer, Architecte Solutions, Ingénieur Infrastructure.',
        'formula':
            'Note finale = (0.4 × Projet) + (0.3 × Stage) + (0.3 × Examen)',
      },
      'SIM': {
        'icon': '📱💡',
        'description':
            'Système d\'information et mobile - Développement d\'applications mobiles et solutions innovantes.',
        'debouches':
            'Développeur Mobile, Architecte Mobile, Chef de projet Mobile, UX/UI Designer.',
        'formula':
            'Note finale = (0.35 × Projet) + (0.35 × Stage) + (0.3 × Examen)',
      },
      'DS': {
        'icon': '📊🔍',
        'description':
            'Data Science - Analyse et exploitation des données massives pour la prise de décision stratégique.',
        'debouches':
            'Data Scientist, Data Engineer, Machine Learning Engineer, Analyste Big Data.',
        'formula':
            'Note finale = (0.4 × Projet) + (0.3 × Stage) + (0.3 × Examen)',
      },
      'IA': {
        'icon': '🤖🧠',
        'description':
            'Intelligence Artificielle - Conception et développement de solutions intelligentes basées sur le Machine Learning et Deep Learning.',
        'debouches':
            'Ingénieur IA, ML Engineer, Computer Vision Engineer, NLP Specialist, Chercheur IA.',
        'formula':
            'Note finale = (0.4 × Projet) + (0.3 × Stage) + (0.3 × Examen)',
      },
      'SE': {
        'icon': '⚙️💻',
        'description':
            'Software Engineering - Méthodologies et pratiques du génie logiciel pour le développement de systèmes robustes.',
        'debouches':
            'Software Engineer, Tech Lead, Architecte Logiciel, DevOps, QA Engineer.',
        'formula':
            'Note finale = (0.35 × Projet) + (0.35 × Stage) + (0.3 × Examen)',
      },
      'NIDS': {
        'icon': '🌐📷',
        'description':
            'Nouvelles technologies de l\'internet, Image et Données Scientifiques - Technologies web avancées et traitement d\'images.',
        'debouches':
            'Développeur Web Full-Stack, Ingénieur Vision par Ordinateur, Expert IoT.',
        'formula':
            'Note finale = (0.3 × Projet) + (0.4 × Stage) + (0.3 × Examen)',
      },
      'RT': {
        'icon': '📡🌐',
        'description':
            'Réseaux et Télécommunications - Conception et administration des infrastructures réseaux.',
        'debouches':
            'Administrateur Réseaux, Ingénieur Télécoms, Network Engineer, Expert VoIP.',
        'formula':
            'Note finale = (0.3 × Projet) + (0.4 × Stage) + (0.3 × Examen)',
      },
      'SEC': {
        'icon': '🔒🛡️',
        'description':
            'Sécurité des Réseaux - Protection des systèmes d\'information et cybersécurité.',
        'debouches':
            'Expert Cybersécurité, Pentester, Analyste Sécurité, RSSI, Consultant Sécurité.',
        'formula':
            'Note finale = (0.35 × Projet) + (0.35 × Stage) + (0.3 × Examen)',
      },
      'IOT': {
        'icon': '🌐🔌',
        'description':
            'Internet des Objets - Développement de solutions connectées et objets intelligents.',
        'debouches':
            'Ingénieur IoT, Développeur Embedded, Architecte IoT, Consultant IoT.',
        'formula':
            'Note finale = (0.4 × Projet) + (0.3 × Stage) + (0.3 × Examen)',
      },
      'GC': {
        'icon': '🏗️📐',
        'description':
            'Génie Civil - Conception et réalisation d\'ouvrages d\'art et infrastructures.',
        'debouches':
            'Ingénieur Génie Civil, Chef de projet BTP, Conducteur de travaux, Bureau d\'études.',
        'formula':
            'Note finale = (0.3 × Projet) + (0.4 × Stage) + (0.3 × Examen)',
      },
      'BTP': {
        'icon': '🏢👷',
        'description':
            'Bâtiment et Travaux Publics - Construction et gestion de projets d\'infrastructure.',
        'debouches':
            'Chef de chantier, Ingénieur BTP, Économiste de la construction, Géotechnicien.',
        'formula':
            'Note finale = (0.3 × Projet) + (0.4 × Stage) + (0.3 × Examen)',
      },
      'EM': {
        'icon': '⚙️🔧',
        'description':
            'Électromécanique - Systèmes électromécaniques et automatisation industrielle.',
        'debouches':
            'Ingénieur Électromécanique, Responsable Maintenance, Automaticien, Technicien Supérieur.',
        'formula':
            'Note finale = (0.3 × Projet) + (0.4 × Stage) + (0.3 × Examen)',
      },
      'AUTO': {
        'icon': '🤖⚡',
        'description':
            'Automatique - Systèmes automatisés et contrôle des processus industriels.',
        'debouches':
            'Ingénieur Automaticien, Chef de projet Automatisation, Expert Contrôle Commande.',
        'formula':
            'Note finale = (0.35 × Projet) + (0.35 × Stage) + (0.3 × Examen)',
      },
    };

    return details[code] ??
        {
          'icon': '📚',
          'description': 'Description complète à venir.',
          'debouches': 'Débouchés professionnels variés.',
          'formula': 'Note finale = (0.3 × Projet) + (0.4 × Stage) + (0.3 × Examen)',
        };
  }
}

