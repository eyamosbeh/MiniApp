# MVVM with Provider - Quick Reference Guide

## 🎯 Principes de Base

### 1. Architecture en 3 Couches

```
┌─────────────┐
│    VIEW     │ ← UI pure (Screens, Widgets)
└──────┬──────┘
       │ Consumer / context.read()
┌──────▼──────┐
│  VIEWMODEL  │ ← Logique métier (Providers)
└──────┬──────┘
       │ Appels méthodes
┌──────▼──────┐
│    MODEL    │ ← Données pures (Entities)
└─────────────┘
```

## 📝 Checklist pour Ajouter une Feature

### Étape 1: Créer l'Entity (Model)
```dart
// lib/entities/my_entity.dart
class MyEntity {
  final int? id;
  final String name;
  
  MyEntity({this.id, required this.name});
  
  // fromJson, toJson, fromMap, toMap, copyWith
}
```

### Étape 2: Créer le Provider (ViewModel)
```dart
// lib/providers/my_provider.dart
class MyProvider extends ChangeNotifier {
  List<MyEntity> _items = [];
  bool _isLoading = false;
  
  List<MyEntity> get items => _items;
  bool get isLoading => _isLoading;
  
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    
    // Logique métier
    
    _isLoading = false;
    notifyListeners();
  }
}
```

### Étape 3: Enregistrer le Provider
```dart
// lib/main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MyProvider()),
  ],
  child: MyApp(),
)
```

### Étape 4: Créer la View (Screen)
```dart
// lib/screens/my_screen.dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return CircularProgressIndicator();
        return ListView.builder(...);
      },
    );
  }
}
```

## 🔥 Patterns Communs

### Pattern 1: Charger des Données au Démarrage
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<MyProvider>().loadData();
  });
}
```

### Pattern 2: Consumer avec État de Chargement
```dart
Consumer<MyProvider>(
  builder: (context, provider, child) {
    // Loading state
    if (provider.isLoading && provider.items.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Error state
    if (provider.errorMessage != null) {
      return ErrorWidget(message: provider.errorMessage!);
    }
    
    // Empty state
    if (provider.items.isEmpty) {
      return EmptyStateWidget();
    }
    
    // Success state
    return ListView.builder(
      itemCount: provider.items.length,
      itemBuilder: (context, index) => ItemWidget(provider.items[index]),
    );
  },
)
```

### Pattern 3: Action avec Feedback
```dart
Future<void> _handleAction(BuildContext context) async {
  final provider = context.read<MyProvider>();
  final success = await provider.performAction();
  
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Action réussie')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur'), backgroundColor: Colors.red),
    );
  }
}
```

### Pattern 4: Dialog avec Provider
```dart
void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => MyDialog(),  // Le Provider est accessible
  );
}
```

## ⚠️ Pièges à Éviter

### ❌ Ne PAS utiliser watch() pour les actions
```dart
// ❌ MAUVAIS
onPressed: () {
  context.watch<MyProvider>().addItem(item);  // Rebuild inutile
}

// ✅ BON
onPressed: () {
  context.read<MyProvider>().addItem(item);  // listen: false
}
```

### ❌ Ne PAS appeler notifyListeners() trop souvent
```dart
// ❌ MAUVAIS
void updateItems(List<Item> items) {
  for (var item in items) {
    _items.add(item);
    notifyListeners();  // N fois!
  }
}

// ✅ BON
void updateItems(List<Item> items) {
  _items.addAll(items);
  notifyListeners();  // 1 fois
}
```

### ❌ Ne PAS mélanger logique métier dans la View
```dart
// ❌ MAUVAIS - Logique dans la View
class BadScreen extends StatelessWidget {
  void _saveData() async {
    final db = await database;
    await db.insert('table', data);
    // ...
  }
}

// ✅ BON - Logique dans le Provider
class GoodScreen extends StatelessWidget {
  void _saveData(BuildContext context) {
    context.read<MyProvider>().saveData();
  }
}
```

## 🎨 Optimisations Performance

### 1. Utiliser Selector pour Rebuilds Ciblés
```dart
// Rebuild seulement quand 'name' change
Selector<MyProvider, String>(
  selector: (context, provider) => provider.name,
  builder: (context, name, child) {
    return Text(name);
  },
)
```

### 2. Utiliser child pour Éviter Rebuilds
```dart
Consumer<MyProvider>(
  builder: (context, provider, child) {
    return Column(
      children: [
        Text(provider.count.toString()),
        child!,  // Ne rebuild jamais
      ],
    );
  },
  child: ExpensiveWidget(),  // Créé une seule fois
)
```

### 3. Split Providers pour Minimiser Rebuilds
```dart
// ❌ MAUVAIS - Un seul gros Provider
class AppProvider {
  List<User> users;
  List<Product> products;
  ThemeMode theme;
  // Tout rebuild si n'importe quoi change!
}

// ✅ BON - Providers séparés
class UserProvider { ... }
class ProductProvider { ... }
class ThemeProvider { ... }
```

## 🗄️ SQLite Patterns

### Pattern 1: Singleton Database Helper
```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
```

### Pattern 2: CRUD dans le Provider
```dart
class MyProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  
  Future<bool> addItem(Item item) async {
    try {
      final id = await _db.insert(item);
      _items.add(item.copyWith(id: id));
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
```

## 📊 État de Chargement Best Practices

```dart
class MyProvider extends ChangeNotifier {
  List<Item> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Private helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
  
  // Action
  Future<void> loadItems() async {
    _setLoading(true);
    _clearError();
    
    try {
      _items = await fetchItems();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
```

## 🧪 Tests Unitaires

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyProvider', () {
    test('initial state', () {
      final provider = MyProvider();
      expect(provider.items, isEmpty);
      expect(provider.isLoading, false);
    });
    
    test('loadItems updates state', () async {
      final provider = MyProvider();
      await provider.loadItems();
      expect(provider.items, isNotEmpty);
    });
  });
}
```

## 📱 Navigation avec Provider

```dart
// Passer des données entre écrans
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(
      item: context.read<MyProvider>().selectedItem,
    ),
  ),
);

// Le Provider est accessible dans le nouvel écran
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provider toujours accessible
    return Consumer<MyProvider>(...);
  }
}
```

## 🎓 Résumé

| Concept | Quand l'utiliser | Exemple |
|---------|------------------|---------|
| `Consumer<T>` | Rebuild automatique | Afficher une liste |
| `context.read<T>()` | Actions sans rebuild | Bouton onClick |
| `context.watch<T>()` | Dans build() | Écouter changements |
| `Selector<T, R>` | Rebuild ciblé | Optimisation |
| `notifyListeners()` | Après changement d'état | Dans le Provider |
| `listen: false` | Éviter rebuilds | Actions |

---

**Tips Final** : Gardez vos Providers simples, testables et focalisés sur une seule responsabilité!

