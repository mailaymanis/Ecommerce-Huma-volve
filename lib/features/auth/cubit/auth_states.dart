sealed class AuthStates {}

//create auth initial state
class AuthInitialState extends AuthStates {}

//create regsister states
class RegsiterLoadingState extends AuthStates {}

class RegsiterSuccessState extends AuthStates {}

class RegsiterErrorState extends AuthStates {
  final String message;
  RegsiterErrorState({required this.message});
}

//create login states
class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {
  final String message;
  LoginErrorState({required this.message});
}
