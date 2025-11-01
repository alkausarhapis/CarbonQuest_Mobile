class Mission {
  final String id;
  final String title;
  final String desc;
  final int points;
  final String icon;
  String status;

  Mission({
    required this.id,
    required this.title,
    required this.desc,
    required this.points,
    required this.icon,
    this.status = 'not_started',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'points': points,
      'icon': icon,
      'status': status,
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
    );
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
}
