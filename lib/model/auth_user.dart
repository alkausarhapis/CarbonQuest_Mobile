class AuthUser {
  static const String baseUrl = 'https://carbonquest-api.bintangap.my.id';

  final String id;
  String nama;
  String namaBelakang;
  String tanggalLahir;
  String email;
  String telepon;
  String bio;
  String? profileImagePath;
  int totalPoints;

  AuthUser({
    required this.id,
    required this.nama,
    required this.namaBelakang,
    required this.tanggalLahir,
    required this.email,
    required this.telepon,
    this.bio = '',
    this.profileImagePath,
    this.totalPoints = 0,
  });

  String get fullName => '$nama $namaBelakang';

  String? get profileImageUrl {
    if (profileImagePath == null || profileImagePath!.isEmpty) {
      return null;
    }
    if (profileImagePath!.startsWith('http')) {
      return profileImagePath;
    }
    return '$baseUrl$profileImagePath';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nama,
      'last_name': namaBelakang,
      'birth_date': tanggalLahir,
      'email': email,
      'phone': telepon,
      'bio': bio,
      'profile_image': profileImagePath ?? '',
      'total_points': totalPoints,
    };
  }

  Map<String, dynamic> toRegisterJson(String password) {
    return {
      'name': nama,
      'last_name': namaBelakang,
      'birth_date': tanggalLahir,
      'email': email,
      'phone': telepon,
      'password': password,
      'profile_image': profileImagePath ?? '',
    };
  }

  static Map<String, dynamic> toLoginJson(String email, String password) {
    return {'email': email, 'password': password};
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      nama: json['name'] ?? json['nama'] ?? '',
      namaBelakang: json['last_name'] ?? json['namaBelakang'] ?? '',
      tanggalLahir: json['birth_date'] ?? json['tanggalLahir'] ?? '',
      email: json['email'] ?? '',
      telepon: json['phone'] ?? json['telepon'] ?? '',
      bio: json['bio'] ?? '',
      profileImagePath: json['profile_image'] ?? json['profileImagePath'],
      totalPoints: json['total_points'] ?? 0,
    );
  }

  factory AuthUser.fromApiResponse(Map<String, dynamic> json) {
    final userData =
        json['data']?['user'] ?? json['user'] ?? json['data'] ?? json;
    return AuthUser(
      id: (userData['id_user'] ?? userData['id'] ?? userData['user_id'] ?? '')
          .toString(),
      nama: (userData['name'] ?? '').toString(),
      namaBelakang: (userData['last_name'] ?? '').toString(),
      tanggalLahir: (userData['birth_date'] ?? '').toString(),
      email: (userData['email'] ?? '').toString(),
      telepon: (userData['phone'] ?? '').toString(),
      bio: (userData['bio'] ?? '').toString(),
      profileImagePath: userData['profile_image']?.toString(),
      totalPoints: userData['total_points'] ?? 0,
    );
  }
}
