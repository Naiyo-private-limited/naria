import 'package:flutter/material.dart';
import 'package:nari/bases/api/news.dart';
import 'package:nari/screens/CategoryNewsPage.dart';
import 'package:nari/screens/components/news_card.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({Key? key}) : super(key: key);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<Map<String, dynamic>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNewsListWithCategories();
  }

  Future<Map<String, dynamic>> fetchNewsListWithCategories() async {
    try {
      final newsData = await NewsAPI().fetchNews();
      final List<NewsAPI> newsList = newsData;
      final List<String> categories =
          newsList.map((news) => news.categories ?? '').toSet().toList();
      return {
        'newsList': newsList,
        'categories': categories,
      };
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<Map<String, dynamic>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!['newsList'].isEmpty) {
          return const Center(child: Text('No news found.'));
        } else {
          List<NewsAPI> newsList = snapshot.data!['newsList'];
          List<String> categories = snapshot.data!['categories'];

          return Column(
            children: [
              SizedBox(
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(categories.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryNewsPage(
                                category: categories[index],
                                newsList: newsList,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 16 : 5,
                            right: index == categories.length - 1 ? 16 : 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final newsItem = newsList[index];

                  return NewsCard(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    onTap: () {
                      print('Tapped on: ${newsItem.title}');
                    },
                    title: newsItem.title ?? "No Title",
                    imageUrl: newsItem.photo ?? 'assets/images/news.jpg',
                    description: newsItem.description ?? "No Description",
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }
}
