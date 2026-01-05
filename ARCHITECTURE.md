# Revision App - MVVM Architecture with Provider

Une application Flutter complète utilisant l'architecture **MVVM (Model-View-ViewModel)** avec **Provider** pour la gestion d'état et **SQLite** pour la persistance des données.

## 📁 Structure du Projet

```
lib/
├── main.dart                  # Point d'entrée de l'application
├── constants/                 # Constantes (URLs API, configurations)
│   ├── api_constants.dart
│   └── app_constants.dart
├── entities/                  # Modèles de données (Models)
│   ├── user.dart
│   └── product.dart
├── providers/                 # Gestion d'état (ViewModels)
│   ├── user_provider.dart
│   ├── product_provider.dart
│   └── theme_provider.dart
├── screens/                   # Pages de l'application (Views)
│   ├── home_screen.dart
│   ├── users_screen.dart
│   └── products_screen.dart
├── widgets/                   # Composants réutilisables (Views)
│   ├── user_list_item.dart
│   ├── user_form_dialog.dart
│   ├── product_card.dart
│   └── product_form_dialog.dart
└── databaseSqFlite/          # Base de données locale
    └── database_helper.dart
```

## 🏗️ Architecture MVVM

### Model (Entities)
**Responsabilité** : Données pures, pas de logique métier
- `User` : Entité utilisateur avec méthodes de sérialisation
- `Product` : Entité produit avec méthodes de conversion JSON/Map

**Caractéristiques** :
- Immutables avec `copyWith()`
- Conversion JSON ↔ Dart Object
- Conversion Map ↔ Dart Object (pour SQLite)

### View (Screens & Widgets)
**Responsabilité** : UI pure, pas de logique métier
- Affichage des données
- Capture des interactions utilisateur
- Délégation au ViewModel

**Caractéristiques** :
- Utilise `Consumer` pour écouter les changements
- Utilise `context.read<Provider>()` avec `listen: false` pour les actions

### ViewModel (Providers)
**Responsabilité** : Logique métier et gestion d'état
- Gestion des données
- Appels API/Base de données
- Notification des changements via `notifyListeners()`

**Caractéristiques** :
- Hérite de `ChangeNotifier`
- Expose des getters pour l'état
- Méthodes asynchrones pour les opérations CRUD

## ✨ Principes Clés

### 1. Séparation des Responsabilités
```dart
// ❌ MAUVAIS - Logique métier dans la View
class BadScreen extends StatefulWidget {
  void _saveUser() async {
    final db = await database;
    await db.insert('users', user.toMap());
    setState(() => users.add(user));
  }
}

// ✅ BON - Logique dans le ViewModel
class GoodScreen extends StatelessWidget {
  void _saveUser(BuildContext context) {
    context.read<UserProvider>().addUser(user);
  }
}
```

### 2. Réactivité avec Provider
```dart
// Consumer rebuild automatiquement quand notifyListeners() est appelé
Consumer<UserProvider>(
  builder: (context, userProvider, child) {
    return ListView.builder(
      itemCount: userProvider.users.length,
      itemBuilder: (context, index) => UserListItem(
        user: userProvider.users[index],
      ),
    );
  },
)
```

### 3. Performance avec `listen: false`
```dart
// ✅ BON - N'écoute pas les changements pour les actions
context.read<UserProvider>().addUser(user);  // listen: false

// ❌ ÉVITER - Rebuild inutile
context.watch<UserProvider>().addUser(user);  // listen: true
```

### 4. État Centralisé
Tous les états sont dans les Providers, accessibles depuis n'importe où :
```dart
// Dans n'importe quelle View
final users = context.watch<UserProvider>().users;
final isLoading = context.watch<UserProvider>().isLoading;
```

## 🗄️ Base de Données SQLite

### Singleton Pattern
```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
}
```

### Opérations CRUD
- `insertUser()` / `insertProduct()`
- `getAllUsers()` / `getAllProducts()`
- `getUserById()` / `getProductById()`
- `updateUser()` / `updateProduct()`
- `deleteUser()` / `deleteProduct()`

## 🎨 Thème Dynamique

Le `ThemeProvider` permet de basculer entre mode clair et sombre :
```dart
// Dans n'importe quelle View
context.read<ThemeProvider>().toggleTheme();
```

## 📦 Dépendances

```yaml
dependencies:
  provider: ^6.1.1          # Gestion d'état
  sqflite: ^2.3.0          # Base de données SQLite
  path_provider: ^2.1.1    # Chemins de fichiers
  http: ^1.1.0             # Requêtes HTTP
  intl: ^0.19.0            # Formatage dates/nombres
```

## 🚀 Lancer l'Application

1. **Installer les dépendances** :
```bash
flutter pub get
```

2. **Lancer l'application** :
```bash
flutter run
```

3. **Build pour production** :
```bash
flutter build apk          # Android
flutter build ios          # iOS
flutter build windows      # Windows
```

## 📝 Exemples d'Utilisation

### Ajouter un Utilisateur
```dart
final user = User(
  name: 'John Doe',
  email: 'john@example.com',
  createdAt: DateTime.now(),
);

// Dans une View
context.read<UserProvider>().addUser(user);
```

### Charger des Données
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<UserProvider>().loadUsers();
  });
}
```

### Écouter les Changements
```dart
Consumer<UserProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) return CircularProgressIndicator();
    if (provider.errorMessage != null) return Text(provider.errorMessage!);
    return ListView.builder(...);
  },
)
```

## 🧪 Testabilité

L'architecture MVVM facilite les tests :

```dart
// Test unitaire d'un Provider
void main() {
  test('UserProvider addUser should add user to list', () async {
    final provider = UserProvider();
    final user = User(name: 'Test', email: 'test@test.com', createdAt: DateTime.now());
    
    await provider.addUser(user);
    
    expect(provider.users.length, 1);
    expect(provider.users.first.name, 'Test');
  });
}
```

## ⚡ Avantages de cette Architecture

### Scalabilité
- ✅ Facile d'ajouter de nouveaux Providers
- ✅ Code modulaire et organisé
- ✅ État global accessible partout

### Maintenabilité
- ✅ Séparation claire des responsabilités
- ✅ Code facile à comprendre
- ✅ Réutilisation des composants

### Performance
- ✅ Rebuilds optimisés avec `Consumer`
- ✅ `listen: false` évite les rebuilds inutiles
- ✅ Singleton pour la base de données

### Testabilité
- ✅ Providers testables indépendamment
- ✅ Mock facile des dépendances
- ✅ Tests unitaires simples

## 📚 Ressources

- [Provider Documentation](https://pub.dev/packages/provider)
- [Flutter MVVM Pattern](https://medium.com/flutter-community/flutter-mvvm-architecture-f8bed2521958)
- [SQLite in Flutter](https://docs.flutter.dev/cookbook/persistence/sqlite)

## 🎯 Fonctionnalités Implémentées

- ✅ Architecture MVVM complète
- ✅ Gestion d'état avec Provider
- ✅ Base de données SQLite locale
- ✅ CRUD complet (Users & Products)
- ✅ Thème clair/sombre
- ✅ Recherche et filtrage
- ✅ Validation des formulaires
- ✅ Gestion des erreurs
- ✅ UI responsive et moderne
- ✅ Navigation multi-écrans

## 👨‍💻 Auteur

Revision App - Exemple d'architecture MVVM avec Provider pour Flutter

---

**Note** : Cette application est un exemple éducatif démontrant les meilleures pratiques d'architecture Flutter avec Provider et SQLite.

