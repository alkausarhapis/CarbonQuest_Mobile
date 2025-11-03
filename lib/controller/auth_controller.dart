import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_user.dart';

class AuthController extends GetxController {
  final Rx<AuthUser?> currentUser = Rx<AuthUser?>(null);
  final RxList<AuthUser> users = <AuthUser>[].obs;
  final RxBool isLoading = false.obs;
  final _storage = GetStorage();

  static const String loggedInKey = 'IS_LOGGED_IN';
  static const String userIdKey = 'CURRENT_USER_ID';

  @override
  void onInit() {
    super.onInit();
    _loadUsers();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(loggedInKey) ?? false;
      final userId = prefs.getString(userIdKey);

      if (isLoggedIn && userId != null) {
        final user = users.firstWhereOrNull((u) => u.id == userId);
        if (user != null) {
          currentUser.value = user;
        }
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
    }
  }

  Future<void> _saveLoginStatus(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(loggedInKey, true);
      await prefs.setString(userIdKey, userId);
    } catch (e) {
      debugPrint('Error saving login status: $e');
    }
  }

  Future<void> _clearLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(loggedInKey);
      await prefs.remove(userIdKey);
    } catch (e) {
      debugPrint('Error clearing login status: $e');
    }
  }

  Future<void> _loadUsers() async {
    try {
      final usersJson = _storage.read('users');
      if (usersJson != null) {
        final List<dynamic> jsonList = json.decode(usersJson);
        users.value = jsonList.map((json) => AuthUser.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
    }
  }

  Future<void> _saveUsers() async {
    try {
      final jsonList = users.map((user) => user.toJson()).toList();
      await _storage.write('users', json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving users: $e');
    }
  }

  Future<bool> register({
    required String nama,
    required String namaBelakang,
    required String tanggalLahir,
    required String email,
    required String telepon,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      if (users.any((user) => user.email == email)) {
        Get.snackbar(
          'Error',
          'Email sudah terdaftar',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return false;
      }

      final newUser = AuthUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: nama,
        namaBelakang: namaBelakang,
        tanggalLahir: tanggalLahir,
        email: email,
        telepon: telepon,
        password: password,
      );

      users.add(newUser);
      await _saveUsers();

      Get.snackbar(
        'Sukses',
        'Registrasi berhasil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );

      isLoading.value = false;
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;

    try {
      final user = users.firstWhereOrNull(
        (user) => user.email == email && user.password == password,
      );

      if (user != null) {
        currentUser.value = user;
        await _saveLoginStatus(user.id);
        isLoading.value = false;
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Email atau password salah',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return false;
    }
  }

  Future<void> logout() async {
    await _clearLoginStatus();
    currentUser.value = null;
  }

  Future<void> updateProfile({
    required String nama,
    required String namaBelakang,
    required String tanggalLahir,
    required String email,
    required String telepon,
    required String bio,
  }) async {
    if (currentUser.value == null) return;

    try {
      currentUser.value!.nama = nama;
      currentUser.value!.namaBelakang = namaBelakang;
      currentUser.value!.tanggalLahir = tanggalLahir;
      currentUser.value!.email = email;
      currentUser.value!.telepon = telepon;
      currentUser.value!.bio = bio;

      final index = users.indexWhere((u) => u.id == currentUser.value!.id);
      if (index != -1) {
        users[index] = currentUser.value!;
        await _saveUsers();
        currentUser.refresh();

        Get.snackbar(
          'Sukses',
          'Data berhasil disimpan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    if (currentUser.value == null) return;

    try {
      currentUser.value!.profileImagePath = imagePath;

      final index = users.indexWhere((u) => u.id == currentUser.value!.id);
      if (index != -1) {
        users[index] = currentUser.value!;
        await _saveUsers();
        currentUser.refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan foto: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
