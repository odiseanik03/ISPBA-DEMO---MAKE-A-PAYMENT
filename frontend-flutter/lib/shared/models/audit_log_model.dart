class AuditLogModel {
  final int id;
  final int? actorUserId;
  final String actionType;
  final String entityType;
  final String? entityId;
  final String? createdAt;

  AuditLogModel({
    required this.id,
    required this.actorUserId,
    required this.actionType,
    required this.entityType,
    required this.entityId,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => AuditLogModel(
        id: json['id'] as int,
        actorUserId: json['actorUserId'] as int?,
        actionType: json['actionType'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String?,
        createdAt: json['createdAt'] as String?,
      );
}
