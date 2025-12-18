import 'dart:convert';

import '../core/api_service.dart';

class Mission {
  final String id;
  final String title;
  final String desc;
  final int points;
  final String icon;
  String status;
  String? workingId; // ID from user-missions for tracking progress
  final String? tags;
  final String? coverImage;
  final String? photoCaption;
  final String? authorName;
  final String? authorRole;
  final String? highlights;
  final DateTime? dateCreated;
  final int? idCreator;

  Mission({
    required this.id,
    required this.title,
    required this.desc,
    required this.points,
    required this.icon,
    this.status = 'not_started',
    this.workingId,
    this.tags,
    this.coverImage,
    this.photoCaption,
    this.authorName,
    this.authorRole,
    this.highlights,
    this.dateCreated,
    this.idCreator,
  });

  // Category icon mapping based on tags or mission type
  static String getCategoryIcon(String? tags, String? category) {
    final tagLower = (tags ?? category ?? '').toLowerCase();
    if (tagLower.contains('transport') || tagLower.contains('kendaraan')) {
      return 'assets/car.png';
    } else if (tagLower.contains('energi') || tagLower.contains('listrik')) {
      return 'assets/listrik.png';
    } else if (tagLower.contains('lingkungan') || tagLower.contains('daun')) {
      return 'assets/daun.png';
    } else if (tagLower.contains('makanan') || tagLower.contains('food')) {
      return 'assets/makanan.png';
    }
    return 'assets/daun.png'; // default
  }

  factory Mission.fromJson(Map<String, dynamic> json) {
    final missionData = json['data'] ?? json;

    // Parse date
    DateTime? parseDate(dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is DateTime) return dateValue;
      try {
        return DateTime.parse(dateValue.toString());
      } catch (e) {
        return null;
      }
    }

    // Get category icon based on tags
    final tags = missionData['tags']?.toString() ?? '';
    final icon = getCategoryIcon(tags, null);

    return Mission(
      id: (missionData['id_mission'] ?? missionData['id'] ?? '').toString(),
      title: missionData['title'] ?? 'No Title',
      desc: missionData['desc'] ?? missionData['description'] ?? '',
      points: int.tryParse(missionData['points']?.toString() ?? '0') ?? 0,
      icon: icon,
      status:
          'not_started', // Default status, will be updated from user-missions
      tags: missionData['tags'],
      coverImage: missionData['cover_image'],
      photoCaption: missionData['photo_caption'],
      authorName: missionData['author_name'],
      authorRole: missionData['author_role'],
      highlights: missionData['highlights'],
      dateCreated: parseDate(missionData['date_created']),
      idCreator: int.tryParse(missionData['id_creator']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'points': points,
      'icon': icon,
      'status': status,
      'tags': tags,
    };
  }

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      points: map['points'],
      icon: map['icon'],
      status: map['status'] ?? 'not_started',
      tags: map['tags'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_mission': id,
      'title': title,
      'desc': desc,
      'points': points,
      'tags': tags,
      'cover_image': coverImage,
      'photo_caption': photoCaption,
      'author_name': authorName,
      'author_role': authorRole,
      'highlights': highlights,
      'date_created': dateCreated?.toIso8601String(),
      'id_creator': idCreator,
    };
  }

  /// Fetch all missions from API
  static Future<List<Mission>> fetchMissions({String? token}) async {
    try {
      final response = await ApiService.get('/missions', token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> missionsJson = jsonData['data'] ?? [];

        return missionsJson.map((json) => Mission.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load missions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching missions: $e');
    }
  }

  /// Start a mission (POST /user-missions)
  static Future<Map<String, dynamic>?> startMission(
    String missionId, {
    required String token,
  }) async {
    try {
      final response = await ApiService.post('/user-missions', {
        'id_mission': int.parse(missionId),
      }, token: token);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData['data'];
      } else {
        throw Exception('Failed to start mission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error starting mission: $e');
    }
  }

  /// Get user's missions (GET /me/missions)
  static Future<List<Map<String, dynamic>>> fetchUserMissions({
    required String token,
  }) async {
    try {
      final response = await ApiService.get('/me/missions', token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['data'] ?? []);
      } else {
        throw Exception('Failed to load user missions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user missions: $e');
    }
  }

  /// Complete a mission (PUT /user-missions/:id)
  static Future<Map<String, dynamic>?> completeMission(
    String workingId, {
    required String token,
    required int points,
  }) async {
    try {
      final response = await ApiService.put('/user-missions/$workingId', {
        'status': 'completed',
        'points': points,
        'completed_time': DateTime.now().toIso8601String(),
      }, token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['data'];
      } else {
        throw Exception('Failed to complete mission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error completing mission: $e');
    }
  }
}

class MissionsData {
  static final Map<String, List<Mission>> missions = {
    'Transportasi': [
      Mission(
        id: 't1',
        title: 'Minggu Bersepeda ke Kantor',
        desc:
            'Pergi ke kantor atau sekolah dengan sepeda setidaknya 3 hari minggu ini daripada menggunakan mobil.',
        points: 65,
        icon: 'assets/car.png',
      ),
      Mission(
        id: 't2',
        title: 'Gunakan Transportasi Umum',
        desc:
            'Gunakan transportasi umum untuk perjalanan harian Anda setidaknya 5 kali minggu ini.',
        points: 50,
        icon: 'assets/car.png',
      ),
      Mission(
        id: 't3',
        title: 'Lebih Banyak Berjalan',
        desc:
            'Berjalan ke tujuan terdekat Anda daripada berkendara. Selesaikan setidaknya 3 kali berjalan.',
        points: 40,
        icon: 'assets/car.png',
      ),
      Mission(
        id: 't4',
        title: 'Urusan dengan Berjalan Kaki',
        desc:
            'Berjalan ke tujuan terdekat Anda daripada berkendara. Selesaikan setidaknya 3 kali berjalan.',
        points: 40,
        icon: 'assets/car.png',
      ),
      Mission(
        id: 't5',
        title: 'Tantangan Berjalan Kaki',
        desc:
            'Berjalan ke tujuan terdekat Anda daripada berkendara. Selesaikan setidaknya 3 kali berjalan.',
        points: 40,
        icon: 'assets/car.png',
      ),
    ],
    'Energi': [
      Mission(
        id: 'e1',
        title: 'Tantangan Hemat Listrik',
        desc:
            'Kurangi penggunaan listrik Anda dengan mematikan lampu yang tidak digunakan, mencabut perangkat dan menurunkan konsumsi energi setidaknya 3 hari.',
        points: 45,
        icon: 'assets/listrik.png',
      ),
      Mission(
        id: 'e2',
        title: 'Penggunaan Tenaga Surya',
        desc:
            'Gunakan pengisi daya atau perangkat bertenaga surya setidaknya satu minggu untuk mengurangi penggunaan listrik.',
        points: 55,
        icon: 'assets/listrik.png',
      ),
      Mission(
        id: 'e3',
        title: 'Tantangan Mandi Air Dingin',
        desc:
            'Mandi air dingin untuk mengurangi penggunaan air panas dan konsumsi energi selama 5 hari.',
        points: 30,
        icon: 'assets/listrik.png',
      ),
      Mission(
        id: 'e4',
        title: 'Tantangan Tanpa Sauna',
        desc:
            'Mandi air dingin untuk mengurangi penggunaan air panas dan konsumsi energi selama 5 hari.',
        points: 30,
        icon: 'assets/listrik.png',
      ),
      Mission(
        id: 'e5',
        title: 'Tantangan Matikan Daya',
        desc:
            'Mandi air dingin untuk mengurangi penggunaan air panas dan konsumsi energi selama 5 hari.',
        points: 30,
        icon: 'assets/listrik.png',
      ),
      Mission(
        id: 'e6',
        title: 'Tantangan Mandi Air Dingin',
        desc:
            'Mandi air dingin untuk mengurangi penggunaan air panas dan konsumsi energi selama 5 hari.',
        points: 30,
        icon: 'assets/listrik.png',
      ),
    ],
    'Lingkungan': [
      Mission(
        id: 'l1',
        title: 'Tanam Pohon',
        desc:
            'Tanam setidaknya satu pohon di taman Anda, taman kota, atau ruang hijau lainnya di area Anda.',
        points: 57,
        icon: 'assets/daun.png',
      ),
      Mission(
        id: 'l2',
        title: 'Kurangi Penggunaan Plastik',
        desc:
            'Hindari penggunaan plastik sekali pakai selama seminggu penuh. Gunakan tas dan botol yang dapat digunakan kembali.',
        points: 48,
        icon: 'assets/daun.png',
      ),
      Mission(
        id: 'l3',
        title: 'Taman Ruang Hijau',
        desc:
            'Buat taman kecil atau tanam bunga di rumah Anda untuk meningkatkan kualitas udara lokal.',
        points: 60,
        icon: 'assets/daun.png',
      ),
      Mission(
        id: 'l4',
        title: 'Lebih Banyak Daur Ulang',
        desc:
            'Buat taman kecil atau tanam bunga di rumah Anda untuk meningkatkan kualitas udara lokal.',
        points: 60,
        icon: 'assets/daun.png',
      ),
      Mission(
        id: 'l5',
        title: 'Tantangan Pakai Ulang',
        desc:
            'Buat taman kecil atau tanam bunga di rumah Anda untuk meningkatkan kualitas udara lokal.',
        points: 60,
        icon: 'assets/daun.png',
      ),
    ],
    'Makanan': [
      Mission(
        id: 'm1',
        title: 'Lewati Daging Merah',
        desc:
            'Hindari makan daging merah (seperti sapi dan kambing) setidaknya 3 hari minggu ini untuk mengurangi jejak karbon Anda.',
        points: 40,
        icon: 'assets/makanan.png',
      ),
      Mission(
        id: 'm2',
        title: 'Minggu Vegetarian',
        desc:
            'Ikuti diet vegetarian selama seminggu penuh untuk mengurangi dampak lingkungan Anda secara signifikan.',
        points: 70,
        icon: 'assets/makanan.png',
      ),
      Mission(
        id: 'm3',
        title: 'Dukung Petani Lokal',
        desc:
            'Beli makanan dari pasar petani lokal daripada supermarket untuk mendukung pertanian berkelanjutan.',
        points: 35,
        icon: 'assets/makanan.png',
      ),
      Mission(
        id: 'm4',
        title: 'Makan Produk Musiman',
        desc:
            'Beli makanan dari pasar petani lokal daripada supermarket untuk mendukung pertanian berkelanjutan.',
        points: 35,
        icon: 'assets/makanan.png',
      ),
      Mission(
        id: 'm5',
        title: 'Senin Tanpa Daging',
        desc:
            'Beli makanan dari pasar petani lokal daripada supermarket untuk mendukung pertanian berkelanjutan.',
        points: 35,
        icon: 'assets/makanan.png',
      ),
    ],
  };

  static List<String> get categories => missions.keys.toList();

  static List<Mission> getMissionsByCategory(String category) {
    return missions[category] ?? [];
  }

  static List<Mission> getActiveMissions() {
    List<Mission> activeMissions = [];
    missions.forEach((category, missionList) {
      activeMissions.addAll(
        missionList.where((mission) => mission.status == 'in_progress'),
      );
    });
    return activeMissions;
  }

  static Mission? getMissionById(String id) {
    for (var missionList in missions.values) {
      try {
        return missionList.firstWhere((mission) => mission.id == id);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  static void startMission(String id) {
    final mission = getMissionById(id);
    if (mission != null && mission.status == 'not_started') {
      mission.status = 'in_progress';
    }
  }

  static void completeMission(String id) {
    final mission = getMissionById(id);
    if (mission != null && mission.status == 'in_progress') {
      mission.status = 'completed';
    }
  }

  /// Fetch missions from API and organize by category
  /// Categories: Transportasi, Energi, Lingkungan, Makanan
  static Future<Map<String, List<Mission>>> fetchMissionsByCategory({
    String? token,
  }) async {
    try {
      final allMissions = await Mission.fetchMissions(token: token);

      // Organize missions by category based on tags
      final Map<String, List<Mission>> categorizedMissions = {
        'Transportasi': [],
        'Energi': [],
        'Lingkungan': [],
        'Makanan': [],
      };

      for (var mission in allMissions) {
        final tags = (mission.tags ?? '').toLowerCase();

        if (tags.contains('transport') || tags.contains('kendaraan')) {
          categorizedMissions['Transportasi']!.add(mission);
        } else if (tags.contains('energi') || tags.contains('listrik')) {
          categorizedMissions['Energi']!.add(mission);
        } else if (tags.contains('lingkungan') ||
            tags.contains('environment')) {
          categorizedMissions['Lingkungan']!.add(mission);
        } else if (tags.contains('makanan') || tags.contains('food')) {
          categorizedMissions['Makanan']!.add(mission);
        } else {
          // Default to Lingkungan if no specific category found
          categorizedMissions['Lingkungan']!.add(mission);
        }
      }

      return categorizedMissions;
    } catch (e) {
      // Return static data as fallback
      return missions;
    }
  }

  /// Update mission statuses from user's missions
  static Future<void> updateMissionStatuses(
    Map<String, List<Mission>> categorizedMissions, {
    required String token,
  }) async {
    try {
      final userMissions = await Mission.fetchUserMissions(token: token);

      // Create a map of mission IDs to their status and working ID
      final Map<String, Map<String, dynamic>> missionDataMap = {};
      for (var userMission in userMissions) {
        final missionId =
            userMission['mission']?['id_mission']?.toString() ?? '';
        final status = userMission['status'] ?? 'not_started';
        final workingId = userMission['id_working']?.toString();
        if (missionId.isNotEmpty) {
          missionDataMap[missionId] = {
            'status': status,
            'workingId': workingId,
          };
        }
      }

      // Update statuses and working IDs in categorized missions
      categorizedMissions.forEach((category, missionList) {
        for (var mission in missionList) {
          if (missionDataMap.containsKey(mission.id)) {
            final data = missionDataMap[mission.id]!;
            mission.status = data['status'];
            mission.workingId = data['workingId'];
          }
        }
      });
    } catch (e) {
      // Silently fail if can't fetch user missions
    }
  }
}
