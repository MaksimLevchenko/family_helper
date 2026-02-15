import 'dart:convert';

class OfflineOperation {
  OfflineOperation({
    required this.id,
    required this.feature,
    required this.action,
    required this.payload,
    required this.createdAt,
    required this.attempt,
  });

  final String id;
  final String feature;
  final String action;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int attempt;

  OfflineOperation copyWith({
    String? id,
    String? feature,
    String? action,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? attempt,
  }) {
    return OfflineOperation(
      id: id ?? this.id,
      feature: feature ?? this.feature,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempt: attempt ?? this.attempt,
    );
  }

  String payloadJson() => jsonEncode(payload);
}
