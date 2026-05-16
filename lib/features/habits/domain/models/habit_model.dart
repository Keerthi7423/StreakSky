import 'habit_frequency.dart';

class HabitModel {
  final String id;
  final String userId;
  final String name;
  final String? emoji;
  final String? colorHex;
  final HabitFrequency frequency;
  final String? category;
  final DateTime? startDate;
  final bool isArchived;
  final int sortOrder;
  final DateTime? createdAt;

  const HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    this.emoji,
    this.colorHex,
    this.frequency = const HabitFrequency(type: FrequencyType.daily),
    this.category,
    this.startDate,
    this.isArchived = false,
    this.sortOrder = 0,
    this.createdAt,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      emoji: json['emoji'] as String?,
      colorHex: json['color_hex'] as String?,
      frequency: json['frequency'] != null 
          ? HabitFrequency.fromJson(json['frequency'] as Map<String, dynamic>)
          : const HabitFrequency(type: FrequencyType.daily),
      category: json['category'] as String?,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date'] as String) : null,
      isArchived: json['is_archived'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'name': name,
      'emoji': emoji,
      'color_hex': colorHex,
      'frequency': frequency.toJson(),
      'category': category,
      'start_date': startDate?.toIso8601String(),
      'is_archived': isArchived,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? emoji,
    String? colorHex,
    HabitFrequency? frequency,
    String? category,
    DateTime? startDate,
    bool? isArchived,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      colorHex: colorHex ?? this.colorHex,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool isDue(DateTime date, {int completionsThisWeek = 0}) {
    if (startDate != null && date.isBefore(startDate!)) {
      return false;
    }
    return frequency.isDue(date, completionsThisWeek: completionsThisWeek);
  }
}
