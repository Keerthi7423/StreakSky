import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/goal_model.dart';
import '../../domain/repositories/goal_repository.dart';

@LazySingleton(as: GoalRepository)
class GoalRepositoryImpl implements GoalRepository {
  final SupabaseClient _supabase;

  GoalRepositoryImpl(this._supabase);

  @override
  Future<List<GoalModel>> getGoals(String userId, {GoalType? type}) async {
    var query = _supabase.from('goals').select().eq('user_id', userId);
    
    if (type != null) {
      query = query.eq('type', type.name);
    }
    
    final response = await query.order('created_at', ascending: false);
    
    return (response as List).map((json) => GoalModel.fromJson(json)).toList();
  }

  @override
  Future<GoalModel> createGoal(GoalModel goal) async {
    final data = goal.toJson();
    if (goal.id.isEmpty) {
      data.remove('id');
    }

    final response = await _supabase
        .from('goals')
        .insert(data)
        .select()
        .single();
    
    return GoalModel.fromJson(response);
  }

  @override
  Future<GoalModel> updateGoal(GoalModel goal) async {
    final response = await _supabase
        .from('goals')
        .update(goal.toJson())
        .eq('id', goal.id)
        .select()
        .single();
    
    return GoalModel.fromJson(response);
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await _supabase.from('goals').delete().eq('id', goalId);
  }

  @override
  Future<void> updateGoalProgress(String goalId, int newValue) async {
    await _supabase
        .from('goals')
        .update({'current_value': newValue})
        .eq('id', goalId);
  }

  @override
  Future<List<GoalModel>> getGoalsByHabitId(String userId, String habitId) async {
    final response = await _supabase
        .from('goals')
        .select()
        .eq('user_id', userId)
        .contains('linked_habits', [habitId]);
    
    return (response as List).map((json) => GoalModel.fromJson(json)).toList();
  }
}
