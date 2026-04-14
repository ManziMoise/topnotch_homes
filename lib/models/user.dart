enum UserRole { admin, manager, host, user }

class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final DateTime createdAt;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.createdAt,
    this.role = UserRole.user,
  });

  String get roleLabel {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.host:
        return 'Host';
      case UserRole.user:
        return 'Guest';
    }
  }
}
