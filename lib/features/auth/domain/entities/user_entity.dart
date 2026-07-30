class UserEntity {
  final String uid;
  final String email;
  final String username;
  final String? phoneNumber;
 
  const UserEntity({
    required this.uid,
    required this.email,
    required this.username,
    this.phoneNumber,
  });
}