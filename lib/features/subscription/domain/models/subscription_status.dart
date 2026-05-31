class SubscriptionStatus {
  final String id;
  final String userId;
  final String status;
  final String planType;
  final DateTime? validUntil;

  const SubscriptionStatus({
    required this.id,
    required this.userId,
    required this.status,
    required this.planType,
    this.validUntil,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String,
      planType: json['plan_type'] as String,
      validUntil: json['valid_until'] != null
          ? DateTime.parse(json['valid_until'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'plan_type': planType,
      'valid_until': validUntil?.toIso8601String(),
    };
  }

  bool get isPro =>
      status == 'active' &&
      (planType == 'monthly' || planType == 'yearly') &&
      (validUntil == null || validUntil!.isAfter(DateTime.now()));
}
