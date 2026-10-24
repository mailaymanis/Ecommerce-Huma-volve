import 'dart:ui' show Color;

import '../../domain/entities/cart_item.dart';

/// Temporary stand-in for the cart API/local storage.
class CartLocalDataSource {
  const CartLocalDataSource();

  Future<List<CartItem>> fetchCartItems() async => const [
    CartItem(
      productId: 1,
      name: 'Classic White Sneakers',
      price: 59.99,
      imageUrl: 'https://picsum.photos/seed/sneakers/300/300',
      quantity: 1,
      selectedColor: Color(0xFFFFFFFF),
      selectedSize: '42',
    ),
    CartItem(
      productId: 3,
      name: 'Wireless Headphones',
      price: 199.99,
      imageUrl: 'https://picsum.photos/seed/headphones/300/300',
      quantity: 2,
      selectedColor: Color(0xFF000000),
      selectedSize: 'One Size',
    ),
  ];
}
