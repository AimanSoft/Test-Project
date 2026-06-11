// User Model
class User {
  final int? id;
  final String username;
  final String password;
  final String? email;

  User({this.id, required this.username, required this.password, this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
    );
  }
}

// Product Model
class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category = 'General',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      category: map['category'],
    );
  }
}

// CartItem Model
class CartItem {
  final int? id;
  final int productId;
  final int userId;
  int quantity;
  final Product? product; // To store product details for easy display

  CartItem({
    this.id,
    required this.productId,
    required this.userId,
    this.quantity = 1,
    this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, {Product? product}) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      userId: map['userId'],
      quantity: map['quantity'],
      product: product,
    );
  }
}
