import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileController extends StateNotifier<AsyncValue<UserProfile?>> {
  final ProfileRepository _repository;
  final Ref _ref;

  ProfileController(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _ref.listen(authStateProvider, (previous, next) async {
      next.when(
        data: (user) async {
          if (user == null) {
            state = const AsyncValue.data(null);
            return;
          }
          final profile = await _repository.getProfile(user.uid);
          if (profile == null) {
            final newProfile = UserProfile(
              id: user.uid,
              email: user.email,
              displayName: user.displayName,
              avatarUrl: user.photoURL,
              createdAt: DateTime.now(),
            );
            await _repository.createProfile(newProfile);
            state = AsyncValue.data(newProfile);
          } else {
            state = AsyncValue.data(profile);
          }
        },
        loading: () => state = const AsyncValue.loading(),
        error: (e, st) => state = AsyncValue.error(e, st),
      );
    }, fireImmediately: true);
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return getIt<ProfileRepository>();
});

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<UserProfile?>>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileController(repo, ref);
});
