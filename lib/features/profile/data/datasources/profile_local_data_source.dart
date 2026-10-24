import 'package:ecommerce_app_huma_volve/core/constants/app_constants.dart';

import '../../domain/entities/user_profile.dart';

/// Temporary stand-in for the authenticated user profile endpoint.
class ProfileLocalDataSource {
  const ProfileLocalDataSource();

  Future<UserProfile> fetchUserProfile() async => const UserProfile(
    name: 'John Doe',
    email: 'john.doe@example.com',
    profilePictureUrl: AppConstants.placeholderAvatarUrl,
  );
}
