import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
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

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              Positioned(
                bottom: 8,
                left: 16,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    // Логика для показа товара
                  },
                  child: const Text('Показать товар',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}
