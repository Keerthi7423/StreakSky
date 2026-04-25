// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:streaksky/core/di/register_module.dart' as _i356;
import 'package:streaksky/features/auth/data/repositories/firebase_auth_service.dart'
    as _i900;
import 'package:streaksky/features/auth/domain/repositories/auth_repository.dart'
    as _i799;
import 'package:streaksky/features/habits/data/repositories/habit_repository_impl.dart'
    as _i524;
import 'package:streaksky/features/habits/domain/repositories/habit_repository.dart'
    as _i593;
import 'package:streaksky/features/profile/data/repositories/supabase_profile_repository.dart'
    as _i425;
import 'package:streaksky/features/profile/domain/repositories/profile_repository.dart'
    as _i293;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i799.AuthRepository>(() => _i900.FirebaseAuthService());
    gh.lazySingleton<_i593.HabitRepository>(
      () => _i524.HabitRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i293.ProfileRepository>(
      () => _i425.SupabaseProfileRepository(gh<_i454.SupabaseClient>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i356.RegisterModule {}
