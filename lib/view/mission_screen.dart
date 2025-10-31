import 'package:flutter/material.dart';

import '../core/styles/app_color.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});
  @override
  _MissionScreenState createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  int _categoryIndex = 0;

  final List<String> _categories = [
    'Transportasi',
    'Energi',
    'Lingkungan',
    'Hewan',
  ];

  final List<String> _categoryIcons = [
    'assets/car.png',
    'assets/listrik.png',
    'assets/daun.png',
    'assets/makanan.png',
  ];

  final Map<String, List<Map<String, dynamic>>> _missions = {
    'Transportasi': [
      {
        'title': 'Minggu Bersepeda ke Kantor',
        'desc':
            'Pergi ke kantor atau sekolah dengan sepeda setidaknya 3 hari minggu ini daripada menggunakan mobil.',
        'points': 65,
        'icon': 'assets/car.png',
      },
      {
        'title': 'Gunakan Transportasi Umum',
        'desc':
            'Gunakan transportasi umum untuk perjalanan harian Anda setidaknya 5 kali minggu ini.',
        'points': 50,
        'icon': 'assets/car.png',
      },
      {
        'title': 'Lebih Banyak Berjalan',
        'desc':
            'Berjalan ke tujuan terdekat Anda daripada berkendara. Selesaikan setidaknya 3 kali berjalan.',
        'points': 40,
        'icon': 'assets/car.png',
      },
      {
        'title': 'Urusan dengan Berjalan Kaki',
        'desc':
            'Berjalan ke tujuan terdekat Anda daripada berkendara. Selesaikan setidaknya 3 kali berjalan.',
        'points': 40,
        'icon': 'assets/car.png',
      },
      {
        'title': 'Tantangan Berjalan Kaki',
        'desc':
            'Berjalan ke tujuan terdekat Anda daripada berkendara. Selesaikan setidaknya 3 kali berjalan.',
        'points': 40,
        'icon': 'assets/car.png',
      },
    ],
    'Energi': [
      {
        'title': 'Tantangan Hemat Listrik',
        'desc':
            'Kurangi penggunaan listrik Anda dengan mematikan lampu yang tidak digunakan, mencabut perangkat dan menurunkan konsumsi energi setidaknya 3 hari.',
        'points': 45,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Penggunaan Tenaga Surya',
        'desc':
            'Gunakan pengisi daya atau perangkat bertenaga surya setidaknya satu minggu untuk mengurangi penggunaan listrik.',
        'points': 55,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Tantangan Mandi Air Dingin',
        'desc':
            'Mandi air dingin untuk mengurangi penggunaan air panas dan konsumsi energi selama 5 hari.',
        'points': 30,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Tantangan Tanpa Sauna',
        'desc':
            'Mandi air dingin untuk mengurangi penggunaan air panas dan konsumsi energi selama 5 hari.',
        'points': 30,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Tantangan Matikan Daya',
        'desc':
            'Mandi air dingin untuk mengurangi penggunaan air panas dan konsumsi energi selama 5 hari.',
        'points': 30,
        'icon': 'assets/listrik.png',
      },
      {
        'title': 'Tantangan Mandi Air Dingin',
        'desc':
            'Mandi air dingin untuk mengurangi penggunaan air panas dan konsumsi energi selama 5 hari.',
        'points': 30,
        'icon': 'assets/listrik.png',
      },
    ],
    'Lingkungan': [
      {
        'title': 'Tanam Pohon',
        'desc':
            'Tanam setidaknya satu pohon di taman Anda, taman kota, atau ruang hijau lainnya di area Anda.',
        'points': 57,
        'icon': 'assets/daun.png',
      },
      {
        'title': 'Kurangi Penggunaan Plastik',
        'desc':
            'Hindari penggunaan plastik sekali pakai selama seminggu penuh. Gunakan tas dan botol yang dapat digunakan kembali.',
        'points': 48,
        'icon': 'assets/daun.png',
      },
      {
        'title': 'Taman Ruang Hijau',
        'desc':
            'Buat taman kecil atau tanam bunga di rumah Anda untuk meningkatkan kualitas udara lokal.',
        'points': 60,
        'icon': 'assets/daun.png',
      },
      {
        'title': 'Lebih Banyak Daur Ulang',
        'desc':
            'Buat taman kecil atau tanam bunga di rumah Anda untuk meningkatkan kualitas udara lokal.',
        'points': 60,
        'icon': 'assets/daun.png',
      },
      {
        'title': 'Tantangan Pakai Ulang',
        'desc':
            'Buat taman kecil atau tanam bunga di rumah Anda untuk meningkatkan kualitas udara lokal.',
        'points': 60,
        'icon': 'assets/daun.png',
      },
    ],
    'Hewan': [
      {
        'title': 'Lewati Daging Merah',
        'desc':
            'Hindari makan daging merah (seperti sapi dan kambing) setidaknya 3 hari minggu ini untuk mengurangi jejak karbon Anda.',
        'points': 40,
        'icon': 'assets/makanan.png',
      },
      {
        'title': 'Minggu Vegetarian',
        'desc':
            'Ikuti diet vegetarian selama seminggu penuh untuk mengurangi dampak lingkungan Anda secara signifikan.',
        'points': 70,
        'icon': 'assets/makanan.png',
      },
      {
        'title': 'Dukung Petani Lokal',
        'desc':
            'Beli makanan dari pasar petani lokal daripada supermarket untuk mendukung pertanian berkelanjutan.',
        'points': 35,
        'icon': 'assets/makanan.png',
      },
      {
        'title': 'Makan Produk Musiman',
        'desc':
            'Beli makanan dari pasar petani lokal daripada supermarket untuk mendukung pertanian berkelanjutan.',
        'points': 35,
        'icon': 'assets/makanan.png',
      },
      {
        'title': 'Senin Tanpa Daging',
        'desc':
            'Beli makanan dari pasar petani lokal daripada supermarket untuk mendukung pertanian berkelanjutan.',
        'points': 35,
        'icon': 'assets/makanan.png',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _missionContent());
  }

  Widget _missionContent() {
    final currentCategory = _categories[_categoryIndex];
    final currentMissions = _missions[currentCategory] ?? [];

    return SafeArea(
      child: Stack(
        children: [
          Container(color: AppColor.primary.color),
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: CurvedClipper(),
              child: Container(color: Colors.white),
            ),
          ),
          // Left cloud
          Positioned(
            left: -70,
            top: 10,
            child: Image.asset(
              'assets/CloudVector.png',
              width: 200,
              height: 100,
            ),
          ),
          // Right cloud
          Positioned(
            right: -50,
            top: 50,
            child: Image.asset(
              'assets/CloudVector.png',
              width: 200,
              height: 100,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Pilih kategori misi Anda",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_categories.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _categoryIndex = index);
                      },
                      child: Image.asset(
                        _categoryIcons[index],
                        width: 80,
                        height: 80,
                      ),
                    );
                  }),
                ),
              ),
              // Title "All Mission"
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    currentCategory,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // ListView Mission
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: currentMissions.length,
                  itemBuilder: (context, idx) {
                    final mission = currentMissions[idx];
                    return _buildMissionCard(mission);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(mission['icon'], width: 70, height: 70),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mission['desc'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${mission['points']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Pts',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 40);

    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
