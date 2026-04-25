import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserProfile?> build() async {
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      data: (user) async {
        if (user == null) return null;
        final profile = await getIt<ProfileRepository>().getProfile(user.uid);
        if (profile == null) {
          final newProfile = UserProfile(
            id: user.uid,
            email: user.email,
            displayName: user.displayName,
            avatarUrl: user.photoURL,
            createdAt: DateTime.now(),
          );
          await getIt<ProfileRepository>().createProfile(newProfile);
          return newProfile;
        }
        return profile;
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      await getIt<ProfileRepository>().updateProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
