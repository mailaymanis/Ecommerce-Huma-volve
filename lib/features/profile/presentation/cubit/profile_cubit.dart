import 'package:ecommerce_app_huma_volve/core/error/result.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/repositories/profile_repository.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/cubit/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit({ProfileRepository? repository})
    : this._(
        repository ?? const ProfileRepositoryImpl(ProfileLocalDataSource()),
      );

  ProfileCubit._(ProfileRepository repository)
    : _getUserProfile = GetUserProfileUseCase(repository),
      super(ProfileInitialState());

  final GetUserProfileUseCase _getUserProfile;

  Future<void> getUserProfile() async {
    emit(ProfileLoadingState());
    final result = await _getUserProfile();
    switch (result) {
      case Success(:final data):
        emit(ProfileSuccessState(user: data));
      case FailureResult(:final failure):
        emit(ProfileErrorState(message: failure.message));
    }
  }
}
