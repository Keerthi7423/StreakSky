class UserProfile {
  final String id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? createdAt;
  final String subscription;
  final DateTime? subExpiresAt;
  final String? timezone;
  final String language;

  const UserProfile({
    required this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.createdAt,
    this.subscription = 'free',
    this.subExpiresAt,
    this.timezone,
    this.language = 'en',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      email: json['email'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      subscription: json['subscription'] as String? ?? 'free',
      subExpiresAt: json['sub_expires_at'] != null ? DateTime.parse(json['sub_expires_at'] as String) : null,
      timezone: json['timezone'] as String?,
      language: json['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'subscription': subscription,
      'sub_expires_at': subExpiresAt?.toIso8601String(),
      'timezone': timezone,
      'language': language,
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
    String? subscription,
    DateTime? subExpiresAt,
    String? timezone,
    String? language,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      subscription: subscription ?? this.subscription,
      subExpiresAt: subExpiresAt ?? this.subExpiresAt,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
    );
  }
}
