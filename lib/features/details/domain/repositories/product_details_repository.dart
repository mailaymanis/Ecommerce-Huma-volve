import '../../../../core/error/result.dart';
import '../../../home/domain/entities/product.dart';

abstract class ProductDetailsRepository {
  Future<Result<Product>> getProduct(int productId);
}
