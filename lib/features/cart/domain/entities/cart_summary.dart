import 'cart_item.dart';

class CartSummary {
  const CartSummary({
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  static const double taxRate = 0.1;

  final double subtotal;
  final double tax;
  final double total;

  factory CartSummary.fromItems(List<CartItem> items) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    final tax = subtotal * taxRate;
    return CartSummary(subtotal: subtotal, tax: tax, total: subtotal + tax);
  }
}
