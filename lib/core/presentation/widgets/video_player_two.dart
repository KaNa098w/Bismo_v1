import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidgetTwo extends StatefulWidget {
  final String url;
  const VideoPlayerWidgetTwo(
      {Key? key, required this.url, required String videoUrl})
      : super(key: key);

  @override
  _VideoPlayerWidgetTwoState createState() => _VideoPlayerWidgetTwoState();
}

class _VideoPlayerWidgetTwoState extends State<VideoPlayerWidgetTwo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(_onVideoEnd);
  }

  void _onVideoEnd() {
    if (_controller.value.position == _controller.value.duration) {
      // Логика для загрузки следующего видео
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  String extractNomenklatureKod(String url) {
    Uri uri = Uri.parse(url);
    List<String> segments = uri.pathSegments;
    return segments.length > 1 ? segments[1] : '';
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
