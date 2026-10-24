import '../../../../core/error/result.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Result<List<CartItem>>> getCartItems();
}
