import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/result.dart';
import '../entities/product.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final HomeRepository _repository;

  Future<Result<List<Product>>> call({
    int? categoryId,
    int offset = 0,
    int limit = AppConstants.productPageSize,
  }) => _repository.getProducts(
    categoryId: categoryId,
    offset: offset,
    limit: limit,
  );
}
