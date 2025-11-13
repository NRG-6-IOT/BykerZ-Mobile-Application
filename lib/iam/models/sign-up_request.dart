class SignUpRequest {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String photoUrl;
  final String password;
  final List<String> roles;

  SignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.password,
    this.roles = const ["ROLE_OWNER"],
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'username': username,
    'email': email,
    'photoUrl': photoUrl,
    'password': password,
    'roles': roles,
  };
}