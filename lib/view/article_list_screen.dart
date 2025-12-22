import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../core/styles/app_color.dart';
import '../model/articles.dart';
import 'article_screen.dart';
import 'widgets/article_widget.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final AuthController _authController = Get.find<AuthController>();
  List<Article> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _authController.getToken();
      final articles = await ArticlesData.getArticles(token: token);
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading articles: $e');
      setState(() {
        _articles = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshArticles() async {
    await _loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Semua Artikel'),
        backgroundColor: AppColor.primary.color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArticles,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _articles.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada artikel',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  return ArticleWidget(
                    imageUrl: article.imageUrl,
                    title: article.title,
                    author: article.author,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleScreen(articleId: article.id),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
