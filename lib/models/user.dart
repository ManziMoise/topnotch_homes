class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.createdAt,
  });
}
