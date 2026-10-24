import '../../../../core/error/result.dart';
import '../entities/category.dart';
import '../entities/product.dart';

abstract class HomeRepository {
  Future<Result<List<Category>>> getCategories();

  Future<Result<List<Product>>> getProducts({int? categoryId});
}
