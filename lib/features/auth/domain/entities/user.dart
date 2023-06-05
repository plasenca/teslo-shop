class User {
  final String id;
  final String email;
  final String fullname;
  final List<String> roles;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.fullname,
    required this.roles,
    required this.token,
  });

  bool get isAdmin => roles.contains('admin');
}
