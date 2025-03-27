class Staff {
  final int id;
  final String name;
  final String username;
  final String mobileNumber;
  final String profilePicture;
  final String userType;
  final String email;
  final String status;

  Staff({
    required this.id,
    required this.name,
    required this.username,
    required this.mobileNumber,
    required this.profilePicture,
    required this.userType,
    required this.email,
    required this.status,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      username: json['username'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      userType: json['user_type'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
