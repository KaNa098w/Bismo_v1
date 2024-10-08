import 'package:bismo/core/presentation/widgets/video_player_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenImage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImage(
      {Key? key, required this.images, required this.initialIndex})
      : super(key: key);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          String mediaUrl = widget.images[index];
          bool isVideo = mediaUrl.endsWith('.mp4');
          return InteractiveViewer(
            child: Center(
              child: isVideo
                  ? VideoPlayerWidgetProduct(videoUrl: mediaUrl)
                  : CachedNetworkImage(
                      imageUrl: mediaUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) {
                        print("Failed to load image $url, error: $error");
                        return Image.network(
                            'https://www.landuse-ca.org/wp-content/uploads/2019/04/no-photo-available.png');
                      },
                      fit: BoxFit.contain,
                    ),
            ),
          );
        },
      ),
    );
  }
}
