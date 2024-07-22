import 'package:bismo/app/catalog/goods/goods_arguments.dart';
import 'package:bismo/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(_onVideoEnd);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Возобновляем воспроизведение при возвращении на страницу
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _onVideoEnd() {
    if (_controller.value.position == _controller.value.duration) {
      // Логика для загрузки следующего видео
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
              GestureDetector(
                onTap: _togglePlayPause,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                right: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    _controller
                        .pause(); // Остановка видео при переходе на товар
                    String nomenklatureKod = extractNomenklatureKod(widget.url);
                    Navigator.pushNamed(
                      context,
                      '/product_goods',
                      arguments: GoodsArguments(
                        '',
                        '',
                        '',
                        0,
                        nomenklatureKod,
                      ),
                    ).then((_) {
                      // Возобновляем воспроизведение при возвращении на страницу
                      _controller.play();
                      setState(() {
                        _isPlaying = true;
                      });
                    });
                  },
                  child: const Text('Показать товар',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
