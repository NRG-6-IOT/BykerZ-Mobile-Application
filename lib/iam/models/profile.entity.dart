class Profile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String photoUrl;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photoUrl
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        photoUrl: json['photoUrl']
    );
  }
}