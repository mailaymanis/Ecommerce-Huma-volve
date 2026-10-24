import 'dart:ui' show Color;

class CartItem {
  const CartItem({
    this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });

  final int? productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;
  final Color selectedColor;
  final String selectedSize;

  double get totalPrice => price * quantity;
}
