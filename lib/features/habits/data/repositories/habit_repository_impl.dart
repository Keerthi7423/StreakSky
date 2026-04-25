import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/habit_model.dart';
import '../../domain/repositories/habit_repository.dart';

@LazySingleton(as: HabitRepository)
class HabitRepositoryImpl implements HabitRepository {
  final SupabaseClient _supabase;

  HabitRepositoryImpl(this._supabase);

  @override
  Future<List<HabitModel>> getHabits(String userId) async {
    final response = await _supabase
        .from('habits')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);
    
    return (response as List).map((json) => HabitModel.fromJson(json)).toList();
  }

  @override
  Future<HabitModel> createHabit(HabitModel habit) async {
    // Remove ID if it's empty to let Supabase generate it
    final data = habit.toJson();
    if (habit.id.isEmpty) {
      data.remove('id');
    }

    final response = await _supabase
        .from('habits')
        .insert(data)
        .select()
        .single();
    
    return HabitModel.fromJson(response);
  }

  @override
  Future<HabitModel> updateHabit(HabitModel habit) async {
    final response = await _supabase
        .from('habits')
        .update(habit.toJson())
        .eq('id', habit.id)
        .select()
        .single();
    
    return HabitModel.fromJson(response);
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await _supabase.from('habits').delete().eq('id', habitId);
  }
}
