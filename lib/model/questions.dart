class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final List<int> pointsPerOption; // Points for each option

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.pointsPerOption,
  });
}

class QuestionsData {
  static final List<QuizQuestion> dailyQuiz = [
    QuizQuestion(
      id: 'q1',
      question:
          'Berapa banyak sampah plastik sekali pakai (contoh: botol minum, kantong kresek, sedotan) yang Anda gunakan hari ini?',
      options: ['0 buah', '1-2 buah', '3-5 buah', 'Lebih dari 5 buah'],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q2',
      question: 'Berapa lama Anda mandi menggunakan air panas hari ini?',
      options: [
        'Tidak mandi air panas',
        'Kurang dari 5 menit',
        '5-10 menit',
        'Lebih dari 10 menit',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q3',
      question:
          'Apakah Anda menggunakan transportasi umum atau kendaraan ramah lingkungan hari ini?',
      options: [
        'Ya, sepeda atau berjalan kaki',
        'Ya, transportasi umum',
        'Tidak, kendaraan pribadi',
        'Tidak, kendaraan berbahan bakar fosil',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q4',
      question: 'Berapa banyak makanan yang Anda buang/sia-siakan hari ini?',
      options: [
        'Tidak ada',
        'Sedikit (kurang dari 100 gram)',
        'Sedang (100-300 gram)',
        'Banyak (lebih dari 300 gram)',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q5',
      question:
          'Apakah Anda mematikan lampu dan perangkat elektronik yang tidak digunakan hari ini?',
      options: [
        'Ya, selalu',
        'Sebagian besar waktu',
        'Kadang-kadang',
        'Jarang/tidak pernah',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q6',
      question:
          'Berapa banyak air kemasan plastik yang Anda konsumsi hari ini?',
      options: [
        'Tidak ada, saya membawa botol sendiri',
        '1 botol',
        '2-3 botol',
        'Lebih dari 3 botol',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q7',
      question: 'Apakah Anda memisahkan sampah organik dan anorganik hari ini?',
      options: [
        'Ya, selalu memisahkan',
        'Sebagian besar waktu',
        'Kadang-kadang',
        'Tidak memisahkan',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q8',
      question:
          'Berapa lama Anda menggunakan AC atau pendingin ruangan hari ini?',
      options: [
        'Tidak menggunakan',
        'Kurang dari 2 jam',
        '2-5 jam',
        'Lebih dari 5 jam',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q9',
      question: 'Apakah Anda mengonsumsi makanan lokal dan musiman hari ini?',
      options: [
        'Ya, semua makanan lokal',
        'Sebagian besar lokal',
        'Sedikit lokal',
        'Tidak ada makanan lokal',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
    QuizQuestion(
      id: 'q10',
      question: 'Apakah Anda mengurangi konsumsi daging hari ini?',
      options: [
        'Ya, vegetarian/vegan hari ini',
        'Ya, hanya makan ikan/ayam',
        'Tidak, makan daging merah',
        'Makan daging berlebihan',
      ],
      pointsPerOption: [10, 7, 4, 1],
    ),
  ];

  static final List<QuizQuestion> weeklyQuiz = [
    QuizQuestion(
      id: 'w1',
      question:
          'Berapa kali Anda menggunakan kendaraan pribadi berbahan bakar fosil minggu ini?',
      options: ['Tidak pernah', '1-2 kali', '3-5 kali', 'Lebih dari 5 kali'],
      pointsPerOption: [50, 35, 20, 5],
    ),
    QuizQuestion(
      id: 'w2',
      question: 'Berapa banyak kantong plastik yang Anda gunakan minggu ini?',
      options: [
        '0, selalu bawa tas sendiri',
        '1-3 kantong',
        '4-7 kantong',
        'Lebih dari 7 kantong',
      ],
      pointsPerOption: [50, 35, 20, 5],
    ),
    QuizQuestion(
      id: 'w3',
      question: 'Apakah Anda melakukan composting atau daur ulang minggu ini?',
      options: [
        'Ya, rutin melakukan keduanya',
        'Ya, salah satunya',
        'Jarang',
        'Tidak pernah',
      ],
      pointsPerOption: [50, 35, 20, 5],
    ),
    QuizQuestion(
      id: 'w4',
      question: 'Berapa hari Anda menerapkan "Meatless Day" minggu ini?',
      options: [
        '7 hari (vegetarian penuh)',
        '3-6 hari',
        '1-2 hari',
        'Tidak ada',
      ],
      pointsPerOption: [50, 35, 20, 5],
    ),
    QuizQuestion(
      id: 'w5',
      question:
          'Apakah Anda menggunakan produk ramah lingkungan (sabun, detergen, dll) minggu ini?',
      options: [
        'Ya, semua produk ramah lingkungan',
        'Sebagian besar',
        'Beberapa saja',
        'Tidak ada',
      ],
      pointsPerOption: [50, 35, 20, 5],
    ),
  ];

  static final List<QuizQuestion> monthlyQuiz = [
    QuizQuestion(
      id: 'm1',
      question: 'Berapa pohon yang Anda tanam bulan ini?',
      options: [
        'Lebih dari 5 pohon',
        '3-5 pohon',
        '1-2 pohon',
        'Tidak menanam pohon',
      ],
      pointsPerOption: [100, 70, 40, 10],
    ),
    QuizQuestion(
      id: 'm2',
      question:
          'Apakah Anda mengikuti program atau komunitas lingkungan bulan ini?',
      options: [
        'Ya, aktif terlibat',
        'Ya, sesekali terlibat',
        'Hanya mengikuti informasi',
        'Tidak terlibat',
      ],
      pointsPerOption: [100, 70, 40, 10],
    ),
    QuizQuestion(
      id: 'm3',
      question:
          'Berapa banyak energi listrik yang Anda hemat bulan ini (dibanding bulan lalu)?',
      options: [
        'Lebih dari 20%',
        '10-20%',
        'Kurang dari 10%',
        'Tidak ada pengurangan',
      ],
      pointsPerOption: [100, 70, 40, 10],
    ),
  ];

  static List<QuizQuestion> getQuizByType(String type) {
    switch (type) {
      case 'daily':
        return dailyQuiz;
      case 'weekly':
        return weeklyQuiz;
      case 'monthly':
        return monthlyQuiz;
      default:
        return dailyQuiz;
    }
  }
}
