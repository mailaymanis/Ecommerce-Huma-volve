import 'package:ecommerce_app_huma_volve/core/error/result.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/usecases/register_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit({AuthRepository? repository})
    : this._(
        repository ?? AuthRepositoryImpl(AuthRemoteDataSource(ApiClient())),
      );

  AuthCubit._(AuthRepository repository)
    : _login = LoginUseCase(repository),
      _register = RegisterUseCase(repository),
      super(AuthInitialState());

  final LoginUseCase _login;
  final RegisterUseCase _register;

  //create regsiter function
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegsiterLoadingState());
    final result = await _register(
      name: name,
      email: email,
      password: password,
    );
    switch (result) {
      case Success():
        emit(RegsiterSuccessState());
      case FailureResult(:final failure):
        emit(RegsiterErrorState(message: failure.message));
    }
  }

  //create login function
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    final result = await _login(email: email, password: password);
    switch (result) {
      case Success():
        emit(LoginSuccessState());
      case FailureResult(:final failure):
        emit(LoginErrorState(message: failure.message));
    }
  }
}
