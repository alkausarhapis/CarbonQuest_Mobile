import 'dart:convert';

import '../core/api_service.dart';

class Article {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String content;
  final String category;
  final DateTime publishedDate;
  final String? description;
  final String? photoCaption;
  final String? photoCredit;
  final String? authorRole;
  final String? place;
  final String? highlights;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.content,
    required this.category,
    required this.publishedDate,
    this.description,
    this.photoCaption,
    this.photoCredit,
    this.authorRole,
    this.place,
    this.highlights,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // Handle both direct article object and nested data structure
    final articleData = json['data'] ?? json;

    // Parse the date
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      if (dateValue is DateTime) return dateValue;
      try {
        return DateTime.parse(dateValue.toString());
      } catch (e) {
        return DateTime.now();
      }
    }

    // Get image URL with base URL if needed
    String getImageUrl(String? imagePath) {
      if (imagePath == null || imagePath.isEmpty) {
        return 'https://via.placeholder.com/800x400';
      }
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      return '${ApiService.baseUrl}$imagePath';
    }

    return Article(
      id: (articleData['id_article'] ?? articleData['id'] ?? '').toString(),
      title: articleData['title'] ?? 'No Title',
      author:
          articleData['author_name'] ??
          articleData['author'] ??
          'Unknown Author',
      imageUrl: getImageUrl(
        articleData['cover_image'] ?? articleData['imageUrl'],
      ),
      content: articleData['content'] ?? '',
      category:
          articleData['topic'] ?? articleData['category'] ?? 'Uncategorized',
      publishedDate: parseDate(
        articleData['date_created'] ?? articleData['publishedDate'],
      ),
      description: articleData['description'],
      photoCaption: articleData['photo_caption'],
      photoCredit: articleData['photo_credit'],
      authorRole: articleData['author_role'],
      place: articleData['place'],
      highlights: articleData['highlights'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_article': id,
      'title': title,
      'author_name': author,
      'cover_image': imageUrl,
      'content': content,
      'topic': category,
      'date_created': publishedDate.toIso8601String(),
      'description': description,
      'photo_caption': photoCaption,
      'photo_credit': photoCredit,
      'author_role': authorRole,
      'place': place,
      'highlights': highlights,
    };
  }

  /// Fetch all articles from API (accessible to users)
  static Future<List<Article>> fetchArticles({String? token}) async {
    try {
      final response = await ApiService.get('/articles', token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> articlesJson = jsonData['data'] ?? [];

        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }

  /// Fetch a single article by ID
  static Future<Article?> fetchArticleById(String id, {String? token}) async {
    try {
      final response = await ApiService.get('/articles/$id', token: token);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Article.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load article: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching article: $e');
    }
  }
}

class ArticlesData {
  /// Fetch articles from API
  static Future<List<Article>> getArticles({String? token}) async {
    return await Article.fetchArticles(token: token);
  }

  /// Fetch article by ID from API
  static Future<Article?> getArticleByIdAsync(
    String id, {
    String? token,
  }) async {
    return await Article.fetchArticleById(id, token: token);
  }
}
