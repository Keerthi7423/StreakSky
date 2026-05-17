import 'package:get_it/get_it.dart' as i1;
import 'package:injectable/injectable.dart' as i2;
import 'package:supabase_flutter/supabase_flutter.dart' as i3;
import 'package:shared_preferences/shared_preferences.dart' as i4;
import 'package:dio/dio.dart' as i5;

import '../../features/auth/data/repositories/firebase_auth_service.dart' as i6;
import '../../features/auth/domain/repositories/auth_repository.dart' as i7;
import '../../features/habits/data/repositories/habit_repository_impl.dart' as i8;
import '../../features/habits/domain/repositories/habit_repository.dart' as i9;
import '../../features/goals/data/repositories/goal_repository_impl.dart' as i10;
import '../../features/goals/domain/repositories/goal_repository.dart' as i11;
import '../../features/streaks/data/services/streak_service.dart' as i12;
import '../../features/streaks/domain/repositories/streak_repository.dart' as i13;
import '../../features/ai_agent/data/datasources/azure_ai_datasource.dart' as i14;
import '../../features/ai_agent/data/datasources/ollama_datasource.dart' as i15;
import '../../features/ai_agent/data/repositories/ai_repository_impl.dart' as i16;
import '../../features/ai_agent/domain/repositories/ai_repository.dart' as i17;
import '../../features/year_review/data/repositories/year_review_repository_impl.dart' as i18;
import '../../features/year_review/domain/repositories/year_review_repository.dart' as i19;

import 'register_module.dart' as i20;

extension GetItInjectableX on i1.GetIt {
  Future<i1.GetIt> init({
    String? environment,
    i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = i2.GetItHelper(this, environment, environmentFilter);
    final registerModule = i20.RegisterModule();

    // Lazy Singletons from Third Party Modules
    gh.lazySingleton<i3.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<i5.Dio>(() => registerModule.dio);
    
    // Pre-resolve SharedPreferences
    final sharedPreferences = await registerModule.prefs;
    gh.factory<i4.SharedPreferences>(() => sharedPreferences);

    // Register Data Sources
    gh.lazySingleton<i14.AzureAiDatasource>(() => i14.AzureAiDatasource(this<i5.Dio>()));
    gh.lazySingleton<i15.OllamaDataSource>(() => i15.OllamaDataSource(
          this<i5.Dio>(),
          this<i14.AzureAiDatasource>(),
        ));

    // Register Repositories & Services
    gh.lazySingleton<i7.AuthRepository>(() => i6.FirebaseAuthService());
    gh.lazySingleton<i9.HabitRepository>(() => i8.HabitRepositoryImpl(this<i3.SupabaseClient>()));
    gh.lazySingleton<i11.GoalRepository>(() => i10.GoalRepositoryImpl(this<i3.SupabaseClient>()));
    gh.lazySingleton<i13.StreakRepository>(() => i12.StreakService(this<i3.SupabaseClient>()));
    gh.lazySingleton<i17.AiRepository>(() => i16.AiRepositoryImpl(this<i15.OllamaDataSource>()));
    gh.lazySingleton<i19.YearReviewRepository>(() => i18.YearReviewRepositoryImpl(
          this<i3.SupabaseClient>(),
          this<i9.HabitRepository>(),
          this<i11.GoalRepository>(),
          this<i13.StreakRepository>(),
          this<i17.AiRepository>(),
        ));

    return this;
  }
}
