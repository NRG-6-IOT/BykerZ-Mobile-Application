class User {
  final int id;
  final String username;

  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }

  User copyWith({
    int? id,
    String? username,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id && other.username == username;
  }

  @override
  int get hashCode => Object.hash(id, username);
}

