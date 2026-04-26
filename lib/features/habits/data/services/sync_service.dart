import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'habit_local_service.dart';

@lazySingleton
class SyncService {
  final HabitLocalService _localService;
  final SupabaseClient _supabase;
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;

  SyncService(this._localService, this._supabase);

  void init() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      // Check if any of the results indicate a connection
      if (results.any((result) => result != ConnectivityResult.none)) {
        syncCompletions();
      }
    });
  }

  Future<void> syncCompletions() async {
    if (_isSyncing) return;
    _isSyncing = true;
    
    try {
      final unsynced = _localService.getUnsyncedCompletions();
      debugPrint('SyncService: Found ${unsynced.length} unsynced completions');
      
      for (final completion in unsynced) {
        try {
          final data = completion.toJson();
          data.remove('synced');
          if (completion.id.isEmpty) {
            data.remove('id');
          }

          await _supabase.from('habit_completions').upsert(data);
          await _localService.markAsSynced(completion.habitId, completion.completedDate);
          
          // Real-time Firestore sync (for today's completions as per PRD)
          final today = DateTime.now();
          final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
          if (completion.completedDate == todayStr) {
            await _syncToFirestore(completion.userId, completion.habitId, true);
          }
          
          debugPrint('SyncService: Synced habit ${completion.habitId} for ${completion.completedDate}');
        } catch (e) {
          debugPrint('SyncService: Error syncing completion: $e');
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncToFirestore(String userId, String habitId, bool isCompleted) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('sync').doc(userId);
      
      if (isCompleted) {
        await docRef.set({
          'habit_completions': FieldValue.arrayUnion([habitId]),
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        await docRef.set({
          'habit_completions': FieldValue.arrayRemove([habitId]),
          'updated_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('SyncService: Firestore sync error: $e');
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
