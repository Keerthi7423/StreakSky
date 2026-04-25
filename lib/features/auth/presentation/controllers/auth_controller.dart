import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Added for Demo Mode
final demoLoggedInProvider = StateProvider<bool>((ref) => false);

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController(this._authRepository, this._ref) : super(const AsyncValue.data(null));


  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    
    // DEMO MODE for Testing/Interviews
    if (email == 'demo@streaksky.com') {
      await Future.delayed(const Duration(seconds: 1));
      _ref.read(demoLoggedInProvider.notifier).state = true;
      state = const AsyncValue.data(null);
      return;
    }

    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmailAndPassword(email, password);
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();

    // DEMO MODE for Testing/Interviews
    if (email == 'demo@streaksky.com') {
      await Future.delayed(const Duration(seconds: 1));
      _ref.read(demoLoggedInProvider.notifier).state = true;
      state = const AsyncValue.data(null);
      return;
    }

    state = await AsyncValue.guard(() async {
      await _authRepository.createUserWithEmailAndPassword(email, password);
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithGoogle();
    });
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithApple();
    });
  }

  Future<void> signInAnonymously() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInAnonymously();
    });
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepository.deleteAccount();
      _ref.read(demoLoggedInProvider.notifier).state = false;
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    _ref.read(demoLoggedInProvider.notifier).state = false;
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
    });
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo, ref);
});

