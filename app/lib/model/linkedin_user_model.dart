class AuthCodeObject {
  AuthCodeObject({required this.code, required this.state});

  final String code;
  final String state;
}

class UserObject {
  UserObject({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String profileImageUrl;
}