enum GoalType {
  weekly,
  monthly,
  career,
}

class GoalModel {
  final String id;
  final String userId;
  final GoalType type;
  final String title;
  final String? description;
  final int? targetValue;
  final int currentValue;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> linkedHabits;
  final int? phase;
  final bool isMilestone;
  final bool isCompleted;
  final bool rolledOver;
  final DateTime? lastResetAt;
  final DateTime? createdAt;

  const GoalModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.description,
    this.targetValue,
    this.currentValue = 0,
    this.startDate,
    this.endDate,
    this.linkedHabits = const [],
    this.phase,
    this.isMilestone = false,
    this.isCompleted = false,
    this.rolledOver = false,
    this.lastResetAt,
    this.createdAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      type: _parseGoalType(json['type'] as String?),
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      targetValue: json['target_value'] as int?,
      currentValue: json['current_value'] as int? ?? 0,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date'] as String) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
      linkedHabits: (json['linked_habits'] as List?)?.map((e) => e as String).toList() ?? [],
      phase: json['phase'] as int?,
      isMilestone: json['is_milestone'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? false,
      rolledOver: json['rolled_over'] as bool? ?? false,
      lastResetAt: json['last_reset_at'] != null ? DateTime.parse(json['last_reset_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  static GoalType _parseGoalType(String? type) {
    switch (type) {
      case 'weekly': return GoalType.weekly;
      case 'monthly': return GoalType.monthly;
      case 'career': return GoalType.career;
      default: return GoalType.weekly;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'type': type.name,
      'title': title,
      'description': description,
      'target_value': targetValue,
      'current_value': currentValue,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'linked_habits': linkedHabits,
      'phase': phase,
      'is_milestone': isMilestone,
      'is_completed': isCompleted,
      'rolled_over': rolledOver,
      'last_reset_at': lastResetAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  GoalModel copyWith({
    String? id,
    String? userId,
    GoalType? type,
    String? title,
    String? description,
    int? targetValue,
    int? currentValue,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? linkedHabits,
    int? phase,
    bool? isMilestone,
    bool? isCompleted,
    bool? rolledOver,
    DateTime? lastResetAt,
    DateTime? createdAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      linkedHabits: linkedHabits ?? this.linkedHabits,
      phase: phase ?? this.phase,
      isMilestone: isMilestone ?? this.isMilestone,
      isCompleted: isCompleted ?? this.isCompleted,
      rolledOver: rolledOver ?? this.rolledOver,
      lastResetAt: lastResetAt ?? this.lastResetAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  double get progress {
    if (targetValue == null || targetValue == 0) return 0;
    return (currentValue / targetValue!).clamp(0.0, 1.0);
  }
}
