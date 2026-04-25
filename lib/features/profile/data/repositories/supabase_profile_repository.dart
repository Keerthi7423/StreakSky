import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient _client;

  SupabaseProfileRepository(this._client);

  @override
  Future<UserProfile?> getProfile(String id) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    // Only update fields that are allowed to be updated by the user
    final data = {
      'display_name': profile.displayName,
      'avatar_url': profile.avatarUrl,
      'timezone': profile.timezone,
      'language': profile.language,
    };
    
    await _client
        .from('users')
        .update(data)
        .eq('id', profile.id);
  }

  @override
  Future<void> createProfile(UserProfile profile) async {
    await _client
        .from('users')
        .insert(profile.toJson());
  }
}
