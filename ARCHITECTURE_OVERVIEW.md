# 🎯 Architecture MVVM - Vue d'Ensemble Complète

## 📐 Diagramme d'Architecture

```
┌────────────────────────────────────────────────────────────┐
│                      MAIN.DART                              │
│                  (MultiProvider Setup)                      │
└───────────────────────┬────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│UserProvider  │ │ProductProvider│ │ThemeProvider │
│(ViewModel)   │ │(ViewModel)    │ │(ViewModel)   │
└──────┬───────┘ └──────┬────────┘ └──────┬───────┘
       │                │                  │
       │ notifyListeners()                 │
       │                │                  │
┌──────▼────────────────▼──────────────────▼───────┐
│              CONSUMER (View Layer)                │
│  ┌──────────────┐  ┌──────────────┐             │
│  │ UsersScreen  │  │ProductsScreen│             │
│  └──────────────┘  └──────────────┘             │
└───────────────────────┬──────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│UserListItem  │ │ProductCard   │ │UserFormDialog│
│(Widget)      │ │(Widget)      │ │(Widget)      │
└──────────────┘ └──────────────┘ └──────────────┘
                        │
                        │ CRUD Operations
                        ▼
        ┌───────────────────────────┐
        │   DatabaseHelper          │
        │   (SQLite Singleton)      │
        └───────────┬───────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
┌──────────┐ ┌──────────┐ ┌──────────┐
│  User    │ │ Product  │ │  ...     │
│ (Entity) │ │ (Entity) │ │          │
└──────────┘ └──────────┘ └──────────┘
```

---

## 🔄 Flow de Données Détaillé

### Exemple: Ajouter un Utilisateur

```
1. USER ACTION (View)
   │
   │  onPressed: () => context.read<UserProvider>().addUser(user)
   │
   ▼

2. VIEWMODEL (Provider)
   │
   │  Future<bool> addUser(User user) async {
   │    _setLoading(true);
   │    try {
   │      // ↓ Appel Database
   │
   ▼

3. DATABASE (SQLite)
   │
   │  final id = await _databaseHelper.insertUser(user);
   │  INSERT INTO users (name, email, createdAt) VALUES (?, ?, ?)
   │
   │  return id; // ↑ Retour avec ID
   │
   ▼

4. VIEWMODEL (Update State)
   │
   │  _users.add(user.copyWith(id: id));
   │  notifyListeners(); // ← IMPORTANT!
   │
   ▼

5. VIEW (Auto Rebuild)
   │
   │  Consumer<UserProvider> détecte le changement
   │  builder: (context, provider, child) {
   │    return ListView.builder(
   │      itemCount: provider.users.length, // ← Nouvelle valeur
   │    );
   │  }
   │
   ▼

6. UI UPDATE
   │
   └─→ Nouvel utilisateur visible dans la liste!
```

---

## 📦 Structure des Fichiers (Détaillée)

### 1. Constants Layer

```dart
lib/constants/
├── api_constants.dart
│   └── URLs API, endpoints, timeout
└── app_constants.dart
    └── Valeurs UI réutilisables
```

**Responsabilité:** Valeurs en dur, configuration

### 2. Entities Layer (MODEL)

```dart
lib/entities/
├── user.dart
│   ├── class User { ... }
│   ├── fromJson() → JSON to Dart
│   ├── toJson() → Dart to JSON
│   ├── fromMap() → SQLite to Dart
│   ├── toMap() → Dart to SQLite
│   └── copyWith() → Immutabilité
│
└── product.dart
    └── (même structure)
```

**Responsabilité:** 
- ✅ Définir la structure des données
- ✅ Conversion JSON/Map
- ❌ PAS de logique métier
- ❌ PAS d'appels DB/API

### 3. Database Layer

```dart
lib/databaseSqFlite/
└── database_helper.dart
    ├── Singleton pattern
    ├── _initDatabase()
    ├── _onCreate()
    ├── insertUser() / getAllUsers() / ...
    └── insertProduct() / getAllProducts() / ...
```

**Responsabilité:**
- ✅ Connexion SQLite
- ✅ Création tables
- ✅ CRUD operations
- ❌ PAS de logique métier

### 4. Providers Layer (VIEWMODEL)

```dart
lib/providers/
├── user_provider.dart
│   ├── extends ChangeNotifier
│   ├── List<User> _users (private state)
│   ├── List<User> get users (public getter)
│   ├── bool _isLoading
│   ├── String? _errorMessage
│   ├── loadUsers() → DB call + notifyListeners()
│   ├── addUser() → DB call + update state
│   ├── updateUser() → DB call + update state
│   └── deleteUser() → DB call + update state
│
├── product_provider.dart
│   └── (même structure)
│
└── theme_provider.dart
    ├── ThemeMode _themeMode
    ├── toggleTheme() → change + notifyListeners()
    └── setThemeMode() → set + notifyListeners()
```

**Responsabilité:**
- ✅ Logique métier
- ✅ Appels DB/API
- ✅ Gestion de l'état
- ✅ notifyListeners()
- ❌ PAS de code UI

### 5. Screens Layer (VIEW)

```dart
lib/screens/
├── home_screen.dart
│   ├── Navigation vers autres écrans
│   └── Toggle thème avec Consumer
│
├── users_screen.dart
│   ├── Consumer<UserProvider>
│   ├── ListView avec états (loading/error/empty/success)
│   ├── context.read<UserProvider>() pour actions
│   └── Navigation vers dialogs
│
└── products_screen.dart
    └── (même structure avec GridView)
```

**Responsabilité:**
- ✅ Structure de la page
- ✅ Consumer pour écouter
- ✅ context.read() pour agir
- ❌ PAS de logique métier
- ❌ PAS d'appels DB directs

### 6. Widgets Layer (VIEW Components)

```dart
lib/widgets/
├── user_list_item.dart
│   └── Affichage d'un User dans une Card
│
├── user_form_dialog.dart
│   ├── Form avec validation
│   └── context.read<UserProvider>().addUser()
│
├── product_card.dart
│   └── Affichage d'un Product en card
│
└── product_form_dialog.dart
    └── (même structure que user_form_dialog)
```

**Responsabilité:**
- ✅ Composants réutilisables
- ✅ UI pure
- ✅ Callbacks pour actions
- ❌ PAS de logique complexe

---

## 🎯 Règles d'Or de l'Architecture MVVM

### ✅ À FAIRE

1. **Dans les Entities (Model)**
   ```dart
   ✅ Définir les propriétés
   ✅ fromJson, toJson, fromMap, toMap
   ✅ copyWith pour immutabilité
   ✅ Equality operators
   ```

2. **Dans les Providers (ViewModel)**
   ```dart
   ✅ extends ChangeNotifier
   ✅ État privé (_users, _isLoading)
   ✅ Getters publics (users, isLoading)
   ✅ Méthodes async pour opérations
   ✅ notifyListeners() après chaque changement
   ✅ Try-catch pour gestion erreurs
   ```

3. **Dans les Screens (View)**
   ```dart
   ✅ Consumer<Provider> pour affichage
   ✅ context.read<Provider>() pour actions
   ✅ Gestion des états (loading/error/empty)
   ✅ Navigation
   ✅ Dialogs et Snackbars
   ```

4. **Dans les Widgets (View Components)**
   ```dart
   ✅ StatelessWidget quand possible
   ✅ Paramètres pour configuration
   ✅ Callbacks pour événements
   ✅ Réutilisables
   ```

### ❌ À ÉVITER

1. **NE JAMAIS faire dans la View**
   ```dart
   ❌ Logique métier
   ❌ Appels DB/API directs
   ❌ setState() (utiliser Provider)
   ❌ Calculs complexes
   ```

2. **NE JAMAIS faire dans le Model**
   ```dart
   ❌ Logique métier
   ❌ Appels DB/API
   ❌ notifyListeners()
   ❌ Import de Provider/Flutter
   ```

3. **NE JAMAIS faire dans le Provider**
   ```dart
   ❌ Import de Screens/Widgets
   ❌ BuildContext en propriété
   ❌ Code UI
   ❌ Navigation directe
   ```

---

## 🔍 Patterns Utilisés

### 1. Singleton Pattern
```dart
// DatabaseHelper
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
}
```
**Pourquoi?** Une seule instance de DB pour toute l'app

### 2. Factory Pattern
```dart
// Dans Entity
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    name: json['name'],
    // ...
  );
}
```
**Pourquoi?** Créer des objets de différentes sources

### 3. Observer Pattern
```dart
// Provider + Consumer
class UserProvider extends ChangeNotifier {
  void addUser(User user) {
    _users.add(user);
    notifyListeners(); // Notifie les observers
  }
}

Consumer<UserProvider>( // Observer
  builder: (context, provider, child) {
    return Text(provider.users.length.toString());
  },
)
```
**Pourquoi?** Rebuild automatique quand état change

### 4. Repository Pattern
```dart
// DatabaseHelper agit comme Repository
class DatabaseHelper {
  Future<List<User>> getAllUsers() { ... }
  Future<int> insertUser(User user) { ... }
  // Abstraction de la source de données
}
```
**Pourquoi?** Séparer logique DB de la logique métier

---

## 📊 Comparaison: Avant vs Après MVVM

### ❌ AVANT (Sans Architecture)
```dart
class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<User> users = [];
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    loadUsers();
  }
  
  Future<void> loadUsers() async {
    setState(() => isLoading = true);
    // Logique DB directement dans la View! ❌
    final db = await DatabaseHelper().database;
    final maps = await db.query('users');
    users = maps.map((m) => User.fromMap(m)).toList();
    setState(() => isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) return CircularProgressIndicator();
    return ListView.builder(...);
  }
}
```

**Problèmes:**
- ❌ Logique métier dans la View
- ❌ Code non réutilisable
- ❌ Difficile à tester
- ❌ setState() partout

### ✅ APRÈS (Avec MVVM)
```dart
// Provider (ViewModel)
class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  
  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();
    _users = await DatabaseHelper().getAllUsers();
    _isLoading = false;
    notifyListeners();
  }
}

// View
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return CircularProgressIndicator();
        return ListView.builder(
          itemCount: provider.users.length,
          itemBuilder: (context, index) => 
            UserListItem(user: provider.users[index]),
        );
      },
    );
  }
}
```

**Avantages:**
- ✅ Séparation claire View/ViewModel
- ✅ Code réutilisable
- ✅ Facile à tester
- ✅ Pas de setState()
- ✅ État centralisé

---

## 🧪 Testabilité

### Test d'un Provider (ViewModel)
```dart
void main() {
  test('UserProvider adds user correctly', () async {
    // Arrange
    final provider = UserProvider();
    final user = User(name: 'Test', email: 'test@test.com', createdAt: DateTime.now());
    
    // Act
    await provider.addUser(user);
    
    // Assert
    expect(provider.users.length, 1);
    expect(provider.users.first.name, 'Test');
  });
}
```

### Test d'un Widget (View)
```dart
testWidgets('UserListItem displays user name', (tester) async {
  // Arrange
  final user = User(name: 'John', email: 'john@test.com', createdAt: DateTime.now());
  
  // Act
  await tester.pumpWidget(
    MaterialApp(home: UserListItem(user: user, onEdit: () {}, onDelete: () {})),
  );
  
  // Assert
  expect(find.text('John'), findsOneWidget);
});
```

---

## 🎓 Résumé Final

| Couche | Fichiers | Responsabilité | Ne JAMAIS |
|--------|----------|----------------|-----------|
| **Model** | `entities/` | Données pures | Logique métier |
| **ViewModel** | `providers/` | Logique métier | Code UI |
| **View** | `screens/`, `widgets/` | UI | Appels DB |
| **Database** | `databaseSqFlite/` | Persistence | Logique métier |

---

**Vous avez maintenant une compréhension complète de l'architecture MVVM avec Provider! 🎉**

