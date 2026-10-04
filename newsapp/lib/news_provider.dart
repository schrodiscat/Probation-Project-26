import 'package:flutter/material.dart';
import 'article_model.dart';
import 'news_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  List<Article> _bookmarkedArticles = [];
  bool _isLoading = false;
  String _selectedCategory = 'general';

  List<Article> get articles => _articles;
  List<Article> get bookmarkedArticles => _bookmarkedArticles;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  Future<void> fetchArticles({String category = 'general', String query = ''}) async {
    _isLoading = true;
    _selectedCategory = category;
    notifyListeners();

    try {
      _articles = await _newsService.fetchNews(category: category, query: query);
    } catch (e) {
      _articles = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleBookmark(Article article) {
    if (_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.remove(article);
    } else {
      _bookmarkedArticles.add(article);
    }
    notifyListeners();
  }

  bool isBookmarked(Article article) {
    return _bookmarkedArticles.contains(article);
  }
}