class UserProfile {
  final int id;
  final String name; // Nama Display di Profile
  final String fullName; // Nama Asli dari User Table
  final String email;
  final String subtitle;
  final String about;
  final List<String> skills;
  final String? avatarUrl;
  final String? cvUrl;
  final String? portfolioUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.fullName,
    required this.email,
    required this.subtitle,
    required this.about,
    required this.skills,
    this.avatarUrl,
    this.cvUrl,
    this.portfolioUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['user_email'] ?? '',
      subtitle: json['subtitle'] ?? '',
      about: json['about'] ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      avatarUrl: json['avatar_url'],
      cvUrl: json['cv_url'],
      portfolioUrl: json['portfolio_url'],
    );
  }
}