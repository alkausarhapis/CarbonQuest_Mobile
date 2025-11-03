class AuthUser {
  final String id;
  String nama;
  String namaBelakang;
  String tanggalLahir;
  String email;
  String telepon;
  String bio;
  String? profileImagePath;
  final String password;

  AuthUser({
    required this.id,
    required this.nama,
    required this.namaBelakang,
    required this.tanggalLahir,
    required this.email,
    required this.telepon,
    this.bio = '',
    this.profileImagePath,
    required this.password,
  });

  String get fullName => '$nama $namaBelakang';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'namaBelakang': namaBelakang,
      'tanggalLahir': tanggalLahir,
      'email': email,
      'telepon': telepon,
      'bio': bio,
      'profileImagePath': profileImagePath,
      'password': password,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      nama: json['nama'],
      namaBelakang: json['namaBelakang'],
      tanggalLahir: json['tanggalLahir'],
      email: json['email'],
      telepon: json['telepon'],
      bio: json['bio'] ?? '',
      profileImagePath: json['profileImagePath'],
      password: json['password'],
    );
  }
}
