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
    final articleData = json['data'] ?? json;

    String? toStringOrNull(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map || value is List) return null;
      return value.toString();
    }

    String toStringOrDefault(dynamic value, String defaultValue) {
      final result = toStringOrNull(value);
      return result ?? defaultValue;
    }

    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      if (dateValue is DateTime) return dateValue;
      try {
        return DateTime.parse(dateValue.toString());
      } catch (e) {
        return DateTime.now();
      }
    }

    String getImageUrl(dynamic imagePath) {
      final imageStr = toStringOrNull(imagePath);
      if (imageStr == null || imageStr.isEmpty) {
        return 'https://placehold.co/800x400';
      }
      if (imageStr.startsWith('http')) {
        return imageStr;
      }
      return '${ApiService.baseUrl}$imageStr';
    }

    String extractContent(dynamic contentValue) {
      if (contentValue == null) return '';
      if (contentValue is String) return contentValue;
      if (contentValue is Map) {
        return toStringOrNull(contentValue['text']) ??
            toStringOrNull(contentValue['body']) ??
            toStringOrNull(contentValue['value']) ??
            '';
      }
      return toStringOrNull(contentValue) ?? '';
    }

    return Article(
      id: toStringOrDefault(articleData['id_article'] ?? articleData['id'], ''),
      title: toStringOrDefault(articleData['title'], 'No Title'),
      author: toStringOrDefault(
        articleData['author_name'] ?? articleData['author'],
        'Unknown Author',
      ),
      imageUrl: getImageUrl(
        articleData['cover_image'] ?? articleData['imageUrl'],
      ),
      content: extractContent(articleData['content']),
      category: toStringOrDefault(
        articleData['topic'] ?? articleData['category'],
        'Uncategorized',
      ),
      publishedDate: parseDate(
        articleData['date_created'] ?? articleData['publishedDate'],
      ),
      description: toStringOrNull(articleData['description']),
      photoCaption: toStringOrNull(articleData['photo_caption']),
      photoCredit: toStringOrNull(articleData['photo_credit']),
      authorRole: toStringOrNull(articleData['author_role']),
      place: toStringOrNull(articleData['place']),
      highlights: toStringOrNull(articleData['highlights']),
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
  static Future<List<Article>> getArticles({String? token}) async {
    return await Article.fetchArticles(token: token);
  }

  static Future<Article?> getArticleByIdAsync(
    String id, {
    String? token,
  }) async {
    return await Article.fetchArticleById(id, token: token);
  }
}
