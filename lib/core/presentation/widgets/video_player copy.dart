import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// VideoPlayerWidget as defined before
class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVisible = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (!_isDisposed) {
        setState(() {}); // Обновляем состояние после инициализации видео.
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!_isDisposed) {
      setState(() {
        _isVisible = info.visibleFraction > 0.5;
        if (_isVisible) {
          _controller.play();
        } else {
          _controller.pause();
        }
      });
    }
  }

  void _handleTap() {
    if (!_isDisposed) {
      setState(() {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.url),
      onVisibilityChanged: _handleVisibilityChanged,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // Настройте радиус скругления
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: GestureDetector(
                        onTap: _handleTap,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 240,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      // Логика для показа товара
                    },
                    child: const Text('Показать товар', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class UnifiedListView extends StatefulWidget {
  const UnifiedListView({super.key});

  @override
  _UnifiedListViewState createState() => _UnifiedListViewState();
}

class _UnifiedListViewState extends State<UnifiedListView> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    // Load your goods and video data here
    List<String> videos = [
      _getVideoUrl(0),
      _getVideoUrl(1),
      _getVideoUrl(2),
      _getVideoUrl(3),
    ];
    List<Goods> goodsList = await _fetchGoods(); // Fetch your goods data

    setState(() {
      items = [...videos, ...goodsList];
    });
  }

  Future<List<Goods>> _fetchGoods() async {
    // Simulate fetching goods from an API or database
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return [
      Goods(nomenklatura: 'Product 1', price: 100),
      Goods(nomenklatura: 'Product 2', price: 200),
      Goods(nomenklatura: 'Product 3', price: 300),
    ];
  }

  String _getVideoUrl(int index) {
    switch (index) {
      case 0:
        return 'https://dulat.object.pscloud.io/7757499451/reels/video_1.MOV';
      case 1:
        return 'https://dulat.object.pscloud.io/7757499451/reelsmp4/video_2.mp4';
      case 2:
        return 'https://dulat.object.pscloud.io/7757499451/reelsmp4/video_3.mp4';
      case 3:
        return 'https://dulat.object.pscloud.io/7757499451/reelsmp4/video_4.mp4';
      default:
        return ''; // Здесь нужно вернуть URL вашего видео по умолчанию или пустую строку
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unified List View'),
      ),
      body: items.isNotEmpty
          ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                if (item is String) {
                  // It's a video URL
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: VideoPlayerWidget(url: item),
                  );
                } else if (item is Goods) {
                  // It's a Goods item
                  return ListTile(
                    title: Text(item.nomenklatura ?? ''),
                    subtitle: Text('Цена: ${item.price}'),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class Goods {
  final String? nomenklatura;
  final double? price;

  Goods({this.nomenklatura, this.price});
}

void main() {
  runApp(const MaterialApp(
    home: UnifiedListView(),
  ));
}
