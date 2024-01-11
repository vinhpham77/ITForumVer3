class UserDTO {
  final String username;
  final String email;

  UserDTO({required this.username, required this.email});

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      username: json['username'],
      email: json['email'],
    );
  }
}
