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
        child: PageView(
          scrollDirection: Axis.vertical,
          children: const <Widget>[
            VideoPlayerWidget(url: 'https://dulat.object.pscloud.io/7757499451/reels/video_1.MOV'),
            VideoPlayerWidget(url: 'https://dulat.object.pscloud.io/7757499451/reelsmp4/video_2.mp4'),
            VideoPlayerWidget(url: 'https://dulat.object.pscloud.io/7757499451/reelsmp4/video_3.mp4'),
            VideoPlayerWidget(url: 'https://dulat.object.pscloud.io/7757499451/reelsmp4/video_4.mp4'),
          ],
        ),
      ),
    );
  }
}
