import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/user_profile.dart';

sealed class ProfileStates {}

//create profile initial state
class ProfileInitialState extends ProfileStates {}

//create profile states
class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {
  final UserProfile user;

  ProfileSuccessState({required this.user});
}

class ProfileErrorState extends ProfileStates {
  final String message;

  ProfileErrorState({required this.message});
}
