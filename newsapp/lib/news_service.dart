import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article_model.dart';

class NewsService {
  // Replace with your actual News API key from newsapi.org
  static const String apiKey = 'f7f0c184f4984daa83b66fbae5266941';
  static const String baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchNews({String category = 'general', String query = ''}) async {
    String url = '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey';
    if (query.isNotEmpty) {
      url = '$baseUrl/everything?q=$query&apiKey=$apiKey';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List articles = data['articles'];
      return articles.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news headlines');
    }
  }
}