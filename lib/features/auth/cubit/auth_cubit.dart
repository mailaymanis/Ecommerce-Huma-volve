import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app_huma_volve/core/helper/api_services.dart';
import 'package:ecommerce_app_huma_volve/features/auth/cubit/auth_states.dart';
import 'package:http/http.dart' as http;

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  //create regsiter function
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegsiterLoadingState());
    try {
      var response = await http.post(
        Uri.parse(ApiServices.registerUrl),
        body: {
          "email": email,
          "name": name,
          "password": password,
          "avatar": "https://i.pinimg.com/236x/47/bf/61/47bf6144a7353efb97edc8006e4c5197.jpg",
        },
      );
      if (response.statusCode == 201) {
        log(response.body);
        emit(RegsiterSuccessState());
      } else {
        emit(RegsiterErrorState(message: response.body));
      }
    } catch (e) {
      emit(RegsiterErrorState(message: e.toString()));
    }
  }

  //create login function
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      var response = await http.post(
        Uri.parse(ApiServices.loginUrl),
        body: {"email": email, "password": password},
      );
      if (response.statusCode == 201) {
        log(response.body);
        emit(LoginSuccessState());
      } else {
        emit(LoginErrorState(message: response.body));
      }
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }
}
