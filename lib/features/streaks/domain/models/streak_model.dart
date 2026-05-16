class StreakModel {
  final String id;
  final String habitId;
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActive;
  final int shieldsHeld;
  final int comebackCount;
  final DateTime? updatedAt;

  const StreakModel({
    required this.id,
    required this.habitId,
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActive,
    this.shieldsHeld = 0,
    this.comebackCount = 0,
    this.updatedAt,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      id: json['id'] as String? ?? '',
      habitId: json['habit_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastActive: json['last_active'] != null ? DateTime.parse(json['last_active'] as String) : null,
      shieldsHeld: json['shields_held'] as int? ?? 0,
      comebackCount: json['comeback_count'] as int? ?? 0,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'habit_id': habitId,
      'user_id': userId,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_active': lastActive?.toIso8601String(),
      'shields_held': shieldsHeld,
      'comeback_count': comebackCount,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StreakModel copyWith({
    String? id,
    String? habitId,
    String? userId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActive,
    int? shieldsHeld,
    int? comebackCount,
    DateTime? updatedAt,
  }) {
    return StreakModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActive: lastActive ?? this.lastActive,
      shieldsHeld: shieldsHeld ?? this.shieldsHeld,
      comebackCount: comebackCount ?? this.comebackCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
