import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/result.dart';
import '../entities/category.dart';
import '../entities/product.dart';

abstract class HomeRepository {
  Future<Result<List<Category>>> getCategories();

  Future<Result<List<Product>>> getProducts({
    int? categoryId,
    int offset = 0,
    int limit = AppConstants.productPageSize,
  });
}
