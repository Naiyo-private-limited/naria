import 'package:flutter/material.dart';
import 'package:nari/bases/api/news.dart';
import 'package:nari/screens/components/news_card.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({Key? key}) : super(key: key);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<NewsAPI>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNewsList(); // Fetch the list of news on initialization
  }

  // Function to fetch news list
  Future<List<NewsAPI>> fetchNewsList() async {
    try {
      final newsData = await NewsAPI().fetchNews();
      return newsData; // Assuming the API returns a list of news objects.
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<NewsAPI>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news found.'));
        } else {
          List<NewsAPI> newsList = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true, // Prevents infinite height issue
            physics:
                const NeverScrollableScrollPhysics(), // Disable scrolling here
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final newsItem = newsList[index];

              return NewsCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onTap: () {
                  // Handle tap on news card (e.g., navigate to details)
                  print('Tapped on: ${newsItem.title}');
                },
                title:
                    newsItem.title ?? "No Title", // Pass the title dynamically
                imageUrl: newsItem.photo ??
                    'assets/images/news.jpg', // Pass the image URL dynamically
                description: newsItem.description ?? "No Description",
              );
            },
          );
        }
      },
    );
  }
}
