class HabitCompletionModel {
  final String id;
  final String habitId;
  final String userId;
  final String completedDate;
  final DateTime? completedAt;
  final bool synced;
  final String? note;

  const HabitCompletionModel({
    this.id = '',
    required this.habitId,
    required this.userId,
    required this.completedDate,
    this.completedAt,
    this.synced = false,
    this.note,
  });

  factory HabitCompletionModel.fromJson(Map<String, dynamic> json) {
    return HabitCompletionModel(
      id: json['id'] as String? ?? '',
      habitId: json['habit_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      completedDate: json['completed_date'] as String? ?? '',
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      synced: json['synced'] as bool? ?? false,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'habit_id': habitId,
      'user_id': userId,
      'completed_date': completedDate,
      'completed_at': completedAt?.toIso8601String(),
      'synced': synced,
      'note': note,
    };
  }

  HabitCompletionModel copyWith({
    String? id,
    String? habitId,
    String? userId,
    String? completedDate,
    DateTime? completedAt,
    bool? synced,
    String? note,
  }) {
    return HabitCompletionModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      completedDate: completedDate ?? this.completedDate,
      completedAt: completedAt ?? this.completedAt,
      synced: synced ?? this.synced,
      note: note ?? this.note,
    );
  }
}
