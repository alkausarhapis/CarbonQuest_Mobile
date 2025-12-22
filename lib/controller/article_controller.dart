import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/articles.dart';
import 'auth_controller.dart';

class ArticleController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final Rx<Article?> currentArticle = Rx<Article?>(null);
  final RxBool isLoading = false.obs;

  Future<void> loadArticle(String articleId) async {
    isLoading.value = true;

    try {
      final token = await _authController.getToken();
      final loadedArticle = await ArticlesData.getArticleByIdAsync(
        articleId,
        token: token,
      );
      currentArticle.value = loadedArticle;
    } catch (e) {
      debugPrint('Error loading article: $e');
      currentArticle.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void clearArticle() {
    currentArticle.value = null;
    isLoading.value = false;
  }
}
