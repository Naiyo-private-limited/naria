import 'package:flutter/material.dart';
import 'package:nari/bases/api/videoGet.dart';
import 'package:nari/screens/components/video_player_screen.dart';

class VideoListWidget extends StatefulWidget {
  const VideoListWidget({Key? key}) : super(key: key);

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  VideoGetAPI? videoData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      VideoGetAPI fetchedVideos = await VideoGetAPI().fetchVideosForUser();
      setState(() {
        videoData = fetchedVideos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error fetching videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : hasError
            ? const Center(child: Text('Failed to load videos.'))
            : SizedBox(
                height: 100, // Set height for the video boxes
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: videoData?.videos?.length ?? 0,
                  itemBuilder: (context, index) {
                    final video = videoData!.videos![index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to video player screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerScreen(videoUrl: video.url!),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                                video.url!), // Use video URL as thumbnail
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: const Icon(Icons.play_circle_outline,
                            color: Colors.white, size: 50),
                      ),
                    );
                  },
                ),
              );
  }
}
