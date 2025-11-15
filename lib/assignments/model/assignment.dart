class Owner {
  final int ownerId;
  final String completeName;

  Owner({
    required this.ownerId,
    required this.completeName,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      ownerId: json['ownerId'] as int,
      completeName: json['completeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'completeName': completeName,
    };
  }

  Owner copyWith({
    int? ownerId,
    String? completeName,
  }) {
    return Owner(
      ownerId: ownerId ?? this.ownerId,
      completeName: completeName ?? this.completeName,
    );
  }

  @override
  String toString() {
    return 'Owner(ownerId: $ownerId, completeName: $completeName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Owner &&
        other.ownerId == ownerId &&
        other.completeName == completeName;
  }

  @override
  int get hashCode => Object.hash(ownerId, completeName);
}

class Mechanic {
  final int mechanicId;
  final String completeName;

  Mechanic({
    required this.mechanicId,
    required this.completeName,
  });

  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
      mechanicId: json['mechanicId'] as int,
      completeName: json['completeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mechanicId': mechanicId,
      'completeName': completeName,
    };
  }

  Mechanic copyWith({
    int? mechanicId,
    String? completeName,
  }) {
    return Mechanic(
      mechanicId: mechanicId ?? this.mechanicId,
      completeName: completeName ?? this.completeName,
    );
  }

  @override
  String toString() {
    return 'Mechanic(mechanicId: $mechanicId, completeName: $completeName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Mechanic &&
        other.mechanicId == mechanicId &&
        other.completeName == completeName;
  }

  @override
  int get hashCode => Object.hash(mechanicId, completeName);
}

class Assignment {
  final int id;
  final Owner owner;
  final Mechanic mechanic;
  final String type;
  final String status;
  final String assignmentCode;
  final String createdAt;

  Assignment({
    required this.id,
    required this.owner,
    required this.mechanic,
    required this.type,
    required this.status,
    required this.assignmentCode,
    required this.createdAt,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as int,
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      mechanic: Mechanic.fromJson(json['mechanic'] as Map<String, dynamic>),
      type: json['type'] as String,
      status: json['status'] as String,
      assignmentCode: json['assignmentCode'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner.toJson(),
      'mechanic': mechanic.toJson(),
      'type': type,
      'status': status,
      'assignmentCode': assignmentCode,
      'createdAt': createdAt,
    };
  }

  Assignment copyWith({
    int? id,
    Owner? owner,
    Mechanic? mechanic,
    String? type,
    String? status,
    String? assignmentCode,
    String? createdAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      mechanic: mechanic ?? this.mechanic,
      type: type ?? this.type,
      status: status ?? this.status,
      assignmentCode: assignmentCode ?? this.assignmentCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Assignment(id: $id, owner: $owner, mechanic: $mechanic, type: $type, status: $status, assignmentCode: $assignmentCode, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Assignment &&
        other.id == id &&
        other.owner == owner &&
        other.mechanic == mechanic &&
        other.type == type &&
        other.status == status &&
        other.assignmentCode == assignmentCode &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      owner,
      mechanic,
      type,
      status,
      assignmentCode,
      createdAt,
    );
  }
}

