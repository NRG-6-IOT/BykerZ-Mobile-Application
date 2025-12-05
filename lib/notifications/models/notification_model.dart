class NotificationModel {
  final int? id;
  final int vehicleId;
  final String title;
  final String message;
  final String type;
  final String severity;
  final bool read;
  final DateTime occurredAt;

  NotificationModel({
    this.id,
    required this.vehicleId,
    required this.title,
    required this.message,
    required this.type,
    required this.severity,
    required this.read,
    required this.occurredAt,
  });

  factory NotificationModel.fromJson(Map<String,dynamic> json){
    return NotificationModel(
      id: json["id"] as int,
      vehicleId: json["vehicleId"] as int,
      title: json["title"] as String,
      message: json["message"] as String,
      type: json["type"] as String,
      severity: json["severity"] as String,
      read: json["read"] as bool,
      occurredAt: DateTime.parse(json["occurredAt"] as String),
    );
  }

  NotificationModel copyWith({
    int? id,
    int? vehicleId,
    String? title,
    String? message,
    String? type,
    String? severity,
    bool? read,
    DateTime? occurredAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      read: read ?? this.read,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }


  NotificationModel markAsRead() {
    return copyWith(read: true);

  }

}