import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['general', 'business', 'technology', 'entertainment', 'sports', 'science'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<NewsProvider>(context, listen: false).fetchArticles()
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'THE VIGIL',
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Color(0xFF8A2BE2)),
        ),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search news...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8A2BE2)),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              onSubmitted: (query) {
                newsProvider.fetchArticles(query: query);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category Selector Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = newsProvider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                  child: ChoiceChip(
                    label: Text(cat.toUpperCase()),
                    selected: isSelected,
                    selectedColor: const Color(0xFF8A2BE2),
                    backgroundColor: const Color(0xFF1E1E1E),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey[400], fontSize: 12),
                    onSelected: (selected) {
                      newsProvider.fetchArticles(category: cat);
                    },
                  ),
                );
              },
            ),
          ),
          // Article List
          Expanded(
            child: newsProvider.isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF8A2BE2)))
                : newsProvider.articles.isEmpty
                    ? const Center(child: Text('No articles found.', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: newsProvider.articles.length,
                        itemBuilder: (context, index) {
                          final article = newsProvider.articles[index];
                          final isBookmarked = newsProvider.isBookmarked(article);
                          return Card(
                            color: const Color(0xFF1E1E1E),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: article.urlToImage.isNotEmpty
                                  ? Image.network(
                                      article.urlToImage,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey),
                                    )
                                  : const Icon(Icons.image, color: Colors.grey),
                              title: Text(
                                article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                article.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  color: const Color(0xFF8A2BE2),
                                ),
                                onPressed: () => newsProvider.toggleBookmark(article),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}