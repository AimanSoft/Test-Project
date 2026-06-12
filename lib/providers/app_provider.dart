import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/database_helper.dart';

class AppProvider with ChangeNotifier {
  User? _currentUser;
  bool _isDarkMode = false;
  List<Product> _products = [];
  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isDarkMode => _isDarkMode;
  List<Product> get products => _products;
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      total += (item.product?.price ?? 0.0) * item.quantity;
    }
    return total;
  }

  AppProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    _products = await DatabaseHelper.instance.getAllProducts();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password, bool rememberMe) async {
    final user = await DatabaseHelper.instance.loginUser(username, password);
    if (user != null) {
      _currentUser = user;
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_username', username);
        await prefs.setString('saved_password', password);
      }
      await loadCart();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password, String email) async {
    try {
      final user = User(username: username, password: password, email: email);
      await DatabaseHelper.instance.registerUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() async {
    _currentUser = null;
    _cartItems = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_username');
    await prefs.remove('saved_password');
    notifyListeners();
  }

  Future<void> loadCart() async {
    if (_currentUser != null) {
      _cartItems = await DatabaseHelper.instance.getCartItems(_currentUser!.id!);
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product) async {
    if (_currentUser != null) {
      final cartItem = CartItem(productId: product.id!, userId: _currentUser!.id!);
      await DatabaseHelper.instance.addToCart(cartItem);
      await loadCart();
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    await DatabaseHelper.instance.removeFromCart(cartItemId);
    await loadCart();
  }

  Future<void> clearCart() async {
    if (_currentUser != null) {
      await DatabaseHelper.instance.clearCart(_currentUser!.id!);
      await loadCart();
    }
  }
}
