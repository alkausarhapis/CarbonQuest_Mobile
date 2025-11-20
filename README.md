# CarbonQuest

Aplikasi mobile untuk meningkatkan kesadaran lingkungan melalui kuis interaktif, misi, dan artikel edukatif tentang perubahan iklim dan keberlanjutan.

## 📱 Tentang Aplikasi

CarbonQuest adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna memahami dan mengurangi jejak karbon mereka melalui:

- **Kuis Interaktif** - Uji pengetahuan Anda tentang lingkungan dengan berbagai jenis kuis
- **Sistem Misi** - Selesaikan tantangan harian untuk kebiasaan ramah lingkungan
- **Artikel Edukatif** - Baca artikel terkini tentang perubahan iklim dan keberlanjutan
- **Papan Peringkat** - Bandingkan skor Anda dengan pengguna lain
- **Profil Pengguna** - Kelola informasi pribadi dan lacak progres Anda

## ✨ Fitur Utama

### 🎯 Autentikasi

- Registrasi pengguna baru dengan validasi email
- Login dengan kredensial yang aman
- Persistensi login menggunakan SharedPreferences
- Manajemen sesi otomatis

### 📝 Sistem Kuis

- Kuis harian, mingguan, dan bulanan
- Sistem penilaian berbasis poin per opsi
- Layar hasil dengan feedback performa
- Navigasi kuis yang intuitif

### 🏆 Misi & Tantangan

- Misi dengan status tracking (Aktif, Selesai, Terkunci)
- Sistem poin dan reward
- Kategori misi beragam

### 📰 Artikel

- Koleksi artikel edukatif tentang lingkungan
- Kategori: Tips, Berita, Panduan
- Tampilan artikel yang mudah dibaca

### 👤 Profil Pengguna

- Upload foto profil dari galeri atau kamera
- Edit informasi pribadi (nama, email, telepon, bio)
- Tampilan profil reaktif di seluruh aplikasi
- Logout dengan konfirmasi

### 📊 Papan Peringkat

- Desain podium untuk top 3
- Daftar peringkat lengkap dengan poin
- Avatar pengguna yang dapat dikustomisasi

## 🛠️ Teknologi yang Digunakan

### Framework & Bahasa

- **Flutter** - Framework UI multiplatform
- **Dart** - Bahasa pemrograman

### State Management & Storage

- **GetX** (v4.6.6) - State management, navigasi, dan dependency injection
- **GetStorage** (v2.1.1) - Penyimpanan data lokal untuk user data
- **SharedPreferences** (v2.3.3) - Persistensi login session

### UI & Styling

- **Google Fonts** (v6.3.2) - Tipografi kustom
- **Iconsax Plus** (v1.0.0) - Set ikon modern

### Fitur Tambahan

- **Image Picker** (v1.1.2) - Upload foto profil dari galeri/kamera
- **Path** (v1.9.1) - Manipulasi path file

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat

- Flutter SDK (versi 3.9.2 atau lebih baru)
- Dart SDK
- Android Studio / VS Code dengan Flutter plugin
- Emulator Android atau perangkat fisik

### Langkah Instalasi

1. **Clone repository**

   ```bash
   git clone https://github.com/alkausarhapis/CarbonQuest_Mobile.git
   cd CarbonQuest_Mobile
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.3.2
  iconsax_plus: ^1.0.0
  get: ^4.6.6
  get_storage: ^2.1.1
  image_picker: ^1.1.2
  path: ^1.9.1
  shared_preferences: ^2.3.3
```

## 🎨 Arsitektur Aplikasi

### State Management - GetX

Aplikasi menggunakan **GetX** untuk state management dengan pattern:

- `Rx` untuk reactive variables
- `Obx()` untuk reactive UI updates
- `Get.find()` untuk dependency injection
- `GetMaterialApp` untuk navigasi

### Data Persistence

1. **GetStorage** - Menyimpan data pengguna (profil, kredensial)
2. **SharedPreferences** - Menyimpan status login dengan key:
   - `IS_LOGGED_IN` - Status login (boolean)
   - `CURRENT_USER_ID` - ID pengguna aktif (string)

### Reactive UI

Semua komponen UI yang menampilkan data pengguna dibungkus dengan `Obx()` untuk update otomatis:

- Profile avatar di semua layar
- Informasi pengguna
- Status misi dan skor

## 🔐 Sistem Autentikasi

### Alur Login

1. User memasukkan email & password
2. `AuthController` memvalidasi kredensial
3. Jika valid, simpan status login ke SharedPreferences
4. Set `currentUser` dan navigasi ke home

### Alur Register

1. User mengisi form registrasi
2. Validasi email (tidak boleh duplikat)
3. Buat objek `AuthUser` baru
4. Simpan ke GetStorage
5. Navigasi ke login screen

### Persistensi Login

- App memeriksa `IS_LOGGED_IN` saat startup
- Jika true, load user dari `CURRENT_USER_ID`
- Auto-navigate ke home screen
- Logout menghapus semua data session

## 📸 Manajemen Gambar

### Upload Foto Profil

- Support galeri dan kamera
- Kompres otomatis (1024x1024, quality 85%)
- Path disimpan di user model
- UI update reaktif menggunakan Obx()

### Penyimpanan

- Path gambar disimpan sebagai string di GetStorage
- File gambar tersimpan di cache image_picker
- Tampilan kondisional: foto user atau default avatar
