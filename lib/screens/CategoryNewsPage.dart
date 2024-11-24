import 'package:flutter/material.dart';
import 'package:nari/bases/Appthemes.dart';
import 'package:nari/bases/api/news.dart';
import 'package:nari/screens/components/news_card.dart';

class CategoryNewsPage extends StatelessWidget {
  final String category;
  final List<NewsAPI> newsList;

  const CategoryNewsPage({
    Key? key,
    required this.category,
    required this.newsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredNews = newsList
        .where((newsItem) => newsItem.categories == category)
        .toList(); // Filter news by selected category

    return Scaffold(
      backgroundColor: AppThemes.background2,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Handle close action
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: AppThemes.background2,
        elevation: 1,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: Container(
          color: Colors.grey[100],
          child: filteredNews.isEmpty
              ? Center(child: Text('No news found for this category.'))
              : ListView.builder(
                  itemCount: filteredNews.length,
                  itemBuilder: (context, index) {
                    final newsItem = filteredNews[index];

                    return NewsCard(
                      screenWidth: MediaQuery.of(context).size.width,
                      screenHeight: MediaQuery.of(context).size.height,
                      onTap: () {
                        print('Tapped on: ${newsItem.title}');
                        // Add navigation to detailed news if needed
                      },
                      title: newsItem.title ?? "No Title",
                      imageUrl: newsItem.photo ?? 'assets/images/news.jpg',
                      description: newsItem.description ?? "No Description",
                    );
                  },
                ),
        ),
      ),
    );
  }
}
