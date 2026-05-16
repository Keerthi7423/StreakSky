// GENERATED CODE - DO NOT MODIFY BY HAND (actually, manually created to fix build_runner issues)

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/ai_agent/data/datasources/ollama_datasource.dart' as _i100;
import '../../features/ai_agent/data/repositories/ai_repository_impl.dart' as _i101;
import '../../features/ai_agent/domain/repositories/ai_repository.dart' as _i102;
import '../../features/auth/data/repositories/firebase_auth_service.dart' as _i103;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i104;
import '../../features/goals/data/repositories/goal_repository_impl.dart' as _i105;
import '../../features/goals/domain/repositories/goal_repository.dart' as _i106;
import '../../features/habits/data/repositories/habit_repository_impl.dart' as _i107;
import '../../features/habits/data/services/habit_local_service.dart' as _i108;
import '../../features/habits/data/services/sync_service.dart' as _i109;
import '../../features/habits/domain/repositories/habit_repository.dart' as _i110;
import '../../features/profile/data/repositories/supabase_profile_repository.dart' as _i111;
import '../../features/profile/domain/repositories/profile_repository.dart' as _i112;
import '../../features/streaks/data/services/streak_service.dart' as _i113;
import '../../features/streaks/domain/repositories/streak_repository.dart' as _i114;
import 'register_module.dart' as _i115;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies of project
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    
    gh.lazySingleton<_i100.OllamaDataSource>(() => _i100.OllamaDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i102.AiRepository>(() => _i101.AiRepositoryImpl(gh<_i100.OllamaDataSource>()));
    
    gh.lazySingleton<_i104.AuthRepository>(() => _i103.FirebaseAuthService());
    gh.lazySingleton<_i108.HabitLocalService>(() => _i108.HabitLocalService());
    gh.lazySingleton<_i110.HabitRepository>(() => _i107.HabitRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i112.ProfileRepository>(() => _i111.SupabaseProfileRepository(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i114.StreakRepository>(() => _i113.StreakService(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i106.GoalRepository>(() => _i105.GoalRepositoryImpl(gh<_i454.SupabaseClient>()));
    
    gh.lazySingleton<_i109.SyncService>(() => _i109.SyncService(
          gh<_i108.HabitLocalService>(),
          gh<_i454.SupabaseClient>(),
        ));
        
    return this;
  }
}

class _$RegisterModule extends _i115.RegisterModule {}
