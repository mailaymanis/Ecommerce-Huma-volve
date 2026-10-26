import '../../../../core/error/result.dart';
import '../../../home/domain/entities/product.dart';
import '../repositories/product_details_repository.dart';

class GetProductDetailsUseCase {
  const GetProductDetailsUseCase(this._repository);

  final ProductDetailsRepository _repository;

  Future<Result<Product>> call(int productId) =>
      _repository.getProduct(productId);
}
