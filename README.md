# 🌎 CarbonQuest

Aplikasi mobile gamifikasi untuk meningkatkan kesadaran lingkungan melalui kuis interaktif, misi, dan artikel edukatif tentang perubahan iklim dan keberlanjutan.

## 📥 Download Aplikasi

**Download APK:**

- [Download CarbonQuest](https://drive.google.com/drive/folders/1jFhOWbdc7BVrS3xr8qWJn1KzOh6Z8_26?usp=sharing)
- Ukuran file: ~50 MB

## 📱 Tentang Aplikasi

CarbonQuest adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna memahami dan mengurangi jejak karbon mereka melalui sistem gamifikasi yang menarik:

- **Kuis Interaktif** - Uji pengetahuan Anda tentang lingkungan dengan sistem poin dinamis
- **Sistem Misi** - Selesaikan tantangan untuk kebiasaan ramah lingkungan
- **Artikel Edukatif** - Baca artikel terkini tentang perubahan iklim dan keberlanjutan
- **Papan Peringkat** - Bandingkan total poin Anda dengan pengguna lain
- **Sistem Level** - Naik level berdasarkan poin yang dikumpulkan
- **Profil Pengguna** - Kelola informasi pribadi dan lacak progres Anda

## ✨ Fitur Utama

### 🎯 Autentikasi & Keamanan

- Registrasi pengguna dengan validasi lengkap
- Login aman dengan JWT token
- Persistensi sesi menggunakan Flutter Secure Storage
- Manajemen token otomatis
- Update password dengan verifikasi

### 📝 Sistem Kuis Gamifikasi

- **Kategori Kuis**: Harian, Mingguan, dan Bulanan
- **Sistem Poin**: Setiap jawaban memiliki poin berbeda (bukan hanya benar/salah)
- **Sesi Quiz**: Tracking waktu mulai dan selesai
- **Perhitungan Skor**: Akumulasi poin dari semua jawaban
- **Hasil Quiz**: Tampilan performa dengan total poin yang didapat
- **Navigasi Intuitif**: Progress bar dan tombol navigasi antar pertanyaan

### 🏆 Sistem Misi & Reward

- **Status Misi**: On Going, Completed dengan tracking waktu
- **Poin Misi**: Dapatkan poin setelah menyelesaikan misi
- **Detail Misi**: Deskripsi lengkap dengan gambar cover
- **Upload Bukti**: Submit foto sebagai bukti penyelesaian misi

### 📰 Artikel Edukatif

- **Kategori Beragam**: Tips, Berita, Panduan Lingkungan
- **Media Kaya**: Cover image, caption, dan kredit foto
- **Metadata Lengkap**: Penulis, peran, lokasi, highlights
- **Tampilan Reader**: UI yang nyaman untuk membaca artikel panjang

### 👤 Profil Pengguna Dinamis

- **Upload Foto Profil**: Dari galeri atau kamera (max 5MB)
- **Edit Profil**: Nama, email, telepon, tanggal lahir
- **Badge Level**: Tampilan level pengguna berdasarkan total poin
  - Pemula (< 500 poin)
  - Pemula Peduli (≥ 500 poin)
  - Aktivis Bumi (≥ 1000 poin)
  - Pejuang Iklim (≥ 1500 poin)
  - Ahli Lingkungan (≥ 2000 poin)
  - Master Hijau (≥ 2500 poin)
- **Sinkronisasi Data**: Update otomatis dari server

### 📊 Papan Peringkat Global

- **Top 3 Podium**: Desain khusus untuk 3 teratas
- **Daftar Lengkap**: Semua pengguna dengan ranking
- **Breakdown Poin**:
  - Total Points (Session + Mission)
  - Session Points (dari kuis)
  - Mission Points (dari misi)
- **Highlight User**: Badge "Kamu" untuk pengguna aktif
- **Avatar Custom**: Foto profil atau default avatar

### 📈 Dashboard & Analytics

- **Grafik Mingguan**: Visualisasi poin harian selama 7 hari
- **Total Poin Hari Ini**: Tracking poin yang didapat hari ini
- **Statistik Misi**: Jumlah misi aktif dan selesai
- **Quick Access**: Akses cepat ke kuis dan artikel

## 🛠️ Teknologi yang Digunakan

### Framework & Bahasa

- **Flutter** - Framework UI cross-platform
- **Dart** - Bahasa pemrograman

### State Management

- **GetX** (v4.6.6) - State management reaktif, routing, dan dependency injection
  - Reactive variables dengan `Rx`
  - UI updates otomatis dengan `Obx()`
  - Controllers untuk business logic
  - Dependency injection dengan `Get.put()` dan `Get.find()`

### Backend & API

- **RESTful API** - Backend Node.js/Express
- **JWT Authentication** - Token-based authentication
- **HTTP** - Network requests
- **Flutter Secure Storage** - Penyimpanan token aman

### Storage & Persistence

- **GetStorage** (v2.1.1) - Local storage untuk data non-sensitif
- **Flutter Secure Storage** - Penyimpanan encrypted untuk token
- **SharedPreferences** (v2.3.3) - Persistensi konfigurasi

### UI & Design

- **Google Fonts** (v6.3.2) - Tipografi custom
- **Iconsax Plus** (v1.0.0) - Icon set modern
- **Material Design 3** - Design system
- **Custom Widgets** - Reusable components

### Media & Files

- **Image Picker** (v1.1.2) - Upload foto dari galeri/kamera
- **Path Provider** - Manajemen file path
- **Cached Network Image** - Caching untuk performa optimal

### Data Visualization

- **Custom Charts** - Grafik mingguan custom
- **AnimatedContainer** - Animasi smooth untuk UI
- **Progress Indicators** - Visual feedback

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  get: ^4.6.6
  get_storage: ^2.1.1

  # UI & Design
  google_fonts: ^6.3.2
  iconsax_plus: ^1.0.0

  # Storage & Security
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.3.3

  # Media & Files
  image_picker: ^1.1.2
  path_provider: ^2.1.5
  path: ^1.9.1

  # Network & API
  http: ^1.2.0

  # Utilities
  intl: ^0.19.0 # Date formatting
```

## 🚀 Panduan Instalasi & Development

### Prasyarat

- **Flutter SDK**: ≥ 3.9.2
- **Dart SDK**: ≥ 3.0.0
- **VS Code** dengan Flutter plugin
- **Android Emulator** atau Perangkat Fisik
- **Git** untuk version control

### Setup Development

1. **Clone Repository**

   ```bash
   git clone https://github.com/alkausarhapis/CarbonQuest_Mobile.git
   cd CarbonQuest_Mobile
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Setup Environment**

   Pastikan API backend sudah running di:

   ```
   https://carbonquest-api.bintangap.my.id
   ```

   Atau update `api_service.dart` dengan URL local:

   ```dart
   static const String baseUrl = 'http://localhost:4000';
   ```

4. **Run Aplikasi**

   ```bash
   # Debug mode
   flutter run

   # Release mode
   flutter run --release

   # Specific device
   flutter run -d <device_id>
   ```

## 🎨 Arsitektur Aplikasi

### Pattern & Architecture

Aplikasi menggunakan **GetX Pattern** dengan struktur:

```
lib/
├── controller/       # GetX Controllers (Business Logic)
│   ├── auth_controller.dart
│   ├── quiz_controller.dart
│   ├── mission_controller.dart
│   ├── home_controller.dart
│   ├── article_controller.dart
│   ├── leaderboard_controller.dart
│   └── image_controller.dart
├── model/           # Data Models
│   ├── auth_user.dart
│   ├── Users.dart (Leaderboard User)
│   ├── quiz.dart (Quiz, Question, Answer)
│   ├── mission.dart
│   ├── articles.dart
│   └── daily_point.dart
├── view/            # UI Screens (StatelessWidget dengan GetX)
│   ├── home_screen.dart
│   ├── quiz_screen.dart
│   ├── mission_screen.dart
│   ├── article_screen.dart
│   ├── leaderboard_screen.dart
│   └── settings_page.dart
├── core/            # Core utilities
│   ├── api_service.dart
│   ├── auth_middleware.dart
│   ├── navigation_route.dart
│   ├── styles/
│   └── widgets/
└── main.dart        # Entry point
```

---
