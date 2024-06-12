import 'package:bismo/core/presentation/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReelsView extends StatefulWidget {
  final String? title;
  const ReelsView({Key? key, this.title}) : super(key: key);

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  List<String> _videoUrls = [];
  bool _isLoading = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final response = await http.get(Uri.parse(
        'http://86.107.45.59/api/movies?phone=7783734209&page=$_currentPage'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newVideos = _extractVideoUrls(data['data']);
      if (newVideos.isNotEmpty) {
        setState(() {
          _videoUrls.addAll(newVideos);
          _isLoading = false;
        });
      }
    } else {
      // Обработка ошибки
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _extractVideoUrls(Map<String, dynamic> data) {
    List<String> urls = [];
    data.forEach((key, value) {
      for (var video in value) {
        urls.add(video['image_path']);
      }
    });
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _videoUrls.length,
              itemBuilder: (context, index) {
                if (index == _videoUrls.length - 1) {
                  _currentPage++;
                  _fetchVideos();
                }
                return VideoPlayerWidget(url: _videoUrls[index]);
              },
            ),
    );
  }
}
