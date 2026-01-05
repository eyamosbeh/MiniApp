import 'package:flutter/foundation.dart';
import '../entities/product.dart';
import '../databaseSqFlite/database_helper.dart';

/// ViewModel for Product management
/// Manages state and business logic for products
class ProductProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  Product? _selectedProduct;

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Product? get selectedProduct => _selectedProduct;

  /// Load all products from database
  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();

    try {
      _products = await _databaseHelper.getAllProducts();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load products: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Add a new product
  Future<bool> addProduct(Product product) async {
    _setLoading(true);
    _clearError();

    try {
      final id = await _databaseHelper.insertProduct(product);
      final newProduct = product.copyWith(id: id);
      _products.add(newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing product
  Future<bool> updateProduct(Product product) async {
    _setLoading(true);
    _clearError();

    try {
      await _databaseHelper.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a product
  Future<bool> deleteProduct(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await _databaseHelper.deleteProduct(id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete product: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Select a product (for detail view)
  void selectProduct(Product? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  /// Search products by name
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    return _products
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Filter products by price range
  List<Product> filterByPrice(double minPrice, double maxPrice) {
    return _products
        .where((product) => product.price >= minPrice && product.price <= maxPrice)
        .toList();
  }

  /// Sort products by price
  void sortByPrice({bool ascending = true}) {
    _products.sort((a, b) =>
      ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price)
    );
    notifyListeners();
  }

  // Private helper methods
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
}

