import '../../../../core/error/result.dart';
import '../entities/category.dart';
import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);

  final HomeRepository _repository;

  Future<Result<List<Category>>> call() => _repository.getCategories();
}
