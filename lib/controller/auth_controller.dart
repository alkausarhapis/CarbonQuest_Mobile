import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/api_service.dart';
import '../model/auth_user.dart';

class AuthController extends GetxController {
  final Rx<AuthUser?> currentUser = Rx<AuthUser?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final _secureStorage = const FlutterSecureStorage();

  static const String tokenKey = 'JWT_TOKEN';
  static const String userKey = 'USER_DATA';

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final token = await _secureStorage.read(key: tokenKey);
      final userData = await _secureStorage.read(key: userKey);

      if (token != null && userData != null) {
        final userJson = json.decode(userData);
        currentUser.value = AuthUser.fromJson(userJson);
        isAuthenticated.value = true;
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
      await _clearAuthData();
    }
  }

  Future<void> _saveAuthData(String token, AuthUser user) async {
    try {
      await _secureStorage.write(key: tokenKey, value: token);
      await _secureStorage.write(
        key: userKey,
        value: json.encode(user.toJson()),
      );
      isAuthenticated.value = true;
    } catch (e) {
      debugPrint('Error saving auth data: $e');
    }
  }

  Future<void> _clearAuthData() async {
    try {
      await _secureStorage.delete(key: tokenKey);
      await _secureStorage.delete(key: userKey);
      isAuthenticated.value = false;
      currentUser.value = null;
    } catch (e) {
      debugPrint('Error clearing auth data: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: tokenKey);
    } catch (e) {
      debugPrint('Error getting token: $e');
      return null;
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
      final user = AuthUser(
        id: '',
        nama: nama,
        namaBelakang: namaBelakang,
        tanggalLahir: tanggalLahir,
        email: email,
        telepon: telepon,
      );

      final response = await ApiService.post(
        '/auth/user/register',
        user.toRegisterJson(password),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        Get.snackbar(
          'Sukses',
          responseData['message'] ?? 'Registrasi berhasil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        isLoading.value = false;
        return true;
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Registrasi gagal',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;

    try {
      final response = await ApiService.post(
        '/auth/user/login',
        AuthUser.toLoginJson(email, password),
      );

      debugPrint('Login response status: ${response.statusCode}');
      debugPrint('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        String? token =
            responseData['token']?.toString() ??
            responseData['data']?['token']?.toString() ??
            responseData['access_token']?.toString() ??
            responseData['data']?['access_token']?.toString();

        if (token == null || token.isEmpty) {
          debugPrint('Full response data: $responseData');
          Get.snackbar(
            'Error',
            'Token tidak ditemukan. Response: ${responseData.keys.join(", ")}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
          isLoading.value = false;
          return false;
        }

        final user = AuthUser.fromApiResponse(responseData);

        await _saveAuthData(token, user);
        currentUser.value = user;

        Get.snackbar(
          'Sukses',
          'Login berhasil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return false;
    }
  }

  Future<void> logout() async {
    await _clearAuthData();
    Get.snackbar(
      'Logout',
      'Anda telah keluar',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Future<bool> fetchUserFromServer() async {
    if (currentUser.value == null) return false;

    try {
      final token = await getToken();
      if (token == null) return false;

      final userId = currentUser.value!.id;
      final response = await ApiService.get('/users/$userId', token: token);

      debugPrint('Fetch user response status: ${response.statusCode}');
      debugPrint('Fetch user response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final user = AuthUser.fromApiResponse(responseData);

        currentUser.value = user;
        await _secureStorage.write(
          key: userKey,
          value: json.encode(user.toJson()),
        );
        currentUser.refresh();

        return true;
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Gagal mengambil data user',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      debugPrint('Fetch user error: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateProfile({
    required String nama,
    required String namaBelakang,
    required String tanggalLahir,
    required String email,
    required String telepon,
    required String bio,
  }) async {
    if (currentUser.value == null) return false;

    try {
      final token = await getToken();
      if (token == null) return false;

      final userId = currentUser.value!.id;
      final updateData = {
        'name': nama,
        'last_name': namaBelakang,
        'birth_date': tanggalLahir,
        'email': email,
        'phone': telepon,
      };

      final response = await ApiService.put(
        '/users/$userId',
        updateData,
        token: token,
      );

      debugPrint('Update profile response status: ${response.statusCode}');
      debugPrint('Update profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final user = AuthUser.fromApiResponse(responseData);
        user.bio = bio;

        currentUser.value = user;
        await _secureStorage.write(
          key: userKey,
          value: json.encode(user.toJson()),
        );
        currentUser.refresh();

        Get.snackbar(
          'Sukses',
          'Data berhasil disimpan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Gagal menyimpan data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      debugPrint('Update profile error: $e');
      Get.snackbar(
        'Error',
        'Gagal menyimpan data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateProfileImage(String imagePath) async {
    if (currentUser.value == null) return false;

    try {
      final token = await getToken();
      if (token == null) return false;

      final userId = currentUser.value!.id;

      final streamedResponse = await ApiService.uploadFile(
        '/users/$userId/profile-image',
        filePath: imagePath,
        fieldName: 'profile_image',
        token: token,
      );

      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Upload image response status: ${response.statusCode}');
      debugPrint('Upload image response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final user = AuthUser.fromApiResponse(responseData);

        currentUser.value = user;
        await _secureStorage.write(
          key: userKey,
          value: json.encode(user.toJson()),
        );
        currentUser.refresh();

        Get.snackbar(
          'Sukses',
          'Foto profil berhasil diupload!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Gagal upload foto',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      debugPrint('Upload image error: $e');
      Get.snackbar(
        'Error',
        'Gagal menyimpan foto: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
