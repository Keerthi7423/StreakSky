import '../models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String id);
  Future<void> updateProfile(UserProfile profile);
  Future<void> createProfile(UserProfile profile);
}
