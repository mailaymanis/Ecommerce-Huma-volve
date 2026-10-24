import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<bool>> call({
    required String email,
    required String password,
  }) => _repository.login(email: email, password: password);
}
