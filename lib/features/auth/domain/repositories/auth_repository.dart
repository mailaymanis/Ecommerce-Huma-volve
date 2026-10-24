import '../../../../core/error/result.dart';

abstract class AuthRepository {
  Future<Result<bool>> login({required String email, required String password});

  Future<Result<bool>> register({
    required String name,
    required String email,
    required String password,
  });
}
