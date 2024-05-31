import 'package:bismo/core/presentation/widgets/video_player.dart';
import 'package:flutter/material.dart';

class ReelsView extends StatefulWidget {
  final String? title;
  const ReelsView({Key? key, this.title}) : super(key: key);

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 4, // Заменяем children на itemCount
          itemBuilder: (context, index) {
            return VideoPlayerWidget(url: _getVideoUrl(index));
          },
        ),
      ),
    );
  }

  String _getVideoUrl(int index) {
    // Здесь вам нужно вернуть URL видео в зависимости от индекса
    switch(index) {
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
}
