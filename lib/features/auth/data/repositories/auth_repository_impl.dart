import 'package:ecommerce_app_huma_volve/core/error/exceptions.dart';
import 'package:ecommerce_app_huma_volve/core/error/failures.dart';
import 'package:ecommerce_app_huma_volve/core/error/result.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<bool>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.login(email: email, password: password);
      return const Success(true);
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } on Exception catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      return const Success(true);
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } on Exception catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }
}
