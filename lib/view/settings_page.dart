import 'package:carbonquest/core/navigation_route.dart';
import 'package:carbonquest/core/styles/app_color.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController(
    text: 'Bahlil',
  );
  final TextEditingController _namaBelakangController = TextEditingController(
    text: 'Lokodi',
  );
  final TextEditingController _tanggalLahirController = TextEditingController(
    text: '18-12-1996',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'bahlillokodi@carbonquest.com',
  );
  final TextEditingController _teleponController = TextEditingController(
    text: '+62xxxxxxxxxx',
  );
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _namaBelakangController.dispose();
    _tanggalLahirController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil disimpan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Konfirmasi Keluar',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari akun Anda?',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                  context,
                  NavigationRoute.loginRoute.name,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColor.primary.color,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildEditableField('Nama', _namaController),
                      _buildEditableField(
                        'Nama Belakang',
                        _namaBelakangController,
                      ),
                      _buildEditableField(
                        'Tanggal Lahir',
                        _tanggalLahirController,
                      ),
                      _buildEditableField('Alamat Email', _emailController),
                      _buildEditableField('Nomor Telepon', _teleponController),
                      const Divider(),
                      _buildEditableField(
                        'Bio Singkat',
                        _bioController,
                        isOptional: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Keluar',
                      style: TextStyle(
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
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    bool isOptional = false,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey[800]),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          validator: isOptional
              ? null
              : (value) {
                  if (value == null || value.isEmpty) {
                    return '$label tidak boleh kosong';
                  }
                  return null;
                },
        ),
        const Divider(),
      ],
    );
  }
}
