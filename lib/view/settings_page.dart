import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Data Pribadi',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),

              // Avatar profil
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFD9E3E8),
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text(
                'Nama Pengguna',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E3A59),
                ),
              ),
              const SizedBox(height: 28),

              // Kartu informasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildInfoTile('Nama', 'Bahlil'),
                    _buildInfoTile('Nama Belakang', 'Lokodi'),
                    _buildInfoTile('Tanggal Lahir', '18-12-1996'),
                    _buildInfoTile('Alamat Email', 'bahlillokodi@carbonquest.com'),
                    _buildInfoTile('Nomor Telepon', '+62xxxxxxxxxx'),
                    const Divider(),
                    ListTile(
                      title: Text(
                        'Tambahkan bio singkat',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                      trailing: const Icon(IconsaxPlusBroken.add_circle),
                      onTap: () {},
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Tombol logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: implementasi logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'KELUAR',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget ubahan untuk setiap baris info
  Widget _buildInfoTile(String title, String subtitle) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          trailing: const Icon(IconsaxPlusBroken.arrow_right_3),
          onTap: () {},
        ),
        const Divider(),
      ],
    );
  }
}
