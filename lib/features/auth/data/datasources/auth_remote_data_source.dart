import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/constants/app_constants.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<void> login({required String email, required String password}) async {
    await _apiClient.post(
      ApiConstants.loginUrl,
      body: {"email": email, "password": password},
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _apiClient.post(
      ApiConstants.registerUrl,
      body: {
        "email": email,
        "name": name,
        "password": password,
        "avatar": AppConstants.registrationAvatarUrl,
      },
    );
  }
}
