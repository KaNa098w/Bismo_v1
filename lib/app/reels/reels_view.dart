import 'dart:convert';
import 'package:bismo/core/presentation/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class ReelsView extends StatefulWidget {
  final String? title;
  const ReelsView({Key? key, this.title}) : super(key: key);

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  final PageController _pageController = PageController();
  List<String> _videos = [];
  final Map<int, VideoPlayerController> _videoControllers = {};
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchVideos(page: 1);
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _onPageChanged() {
    final int nextPage = _pageController.page!.round();
    if (nextPage != _currentPage) {
      _currentPage = nextPage;
      if (_currentPage < _videos.length) {
        _loadVideoController(_videos[nextPage], nextPage);
      }
      if (_currentPage == _videos.length - 1 && _hasMore) {
        _fetchVideos(page: (_currentPage ~/ 10) + 2);
      }
    }
  }

  Future<void> _fetchVideos({required int page}) async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final List<String> videos = await _fetchVideosFromApi(page: page);
      if (videos.isEmpty) {
        _hasMore = false;
      } else {
        setState(() {
          _videos.addAll(videos);
        });
        // Preload the next video controllers
        for (int i = _videos.length - videos.length; i < _videos.length; i++) {
          _loadVideoController(_videos[i], i);
        }
      }
    } catch (error) {
      // Handle error appropriately
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> _fetchVideosFromApi({required int page}) async {
    final response = await http.get(
      Uri.parse('http://86.107.45.59/api/movies?phone=7783734209&page=$page'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('data')) {
        final Map<String, dynamic> videosData = data['data'];
        final List<dynamic> videoList = videosData.values
            .expand((element) => element as List<dynamic>)
            .toList();
        final List<String> videoUrls = [];

        for (var video in videoList) {
          final url = video['image_path'] as String;
          if (await _isValidVideoUrl(url)) {
            videoUrls.add(url);
          }
        }
        return videoUrls;
      } else {
        throw Exception('No videos found');
      }
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<bool> _isValidVideoUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200 &&
          response.headers['content-type']?.startsWith('video/') == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadVideoController(String url, int index) async {
    if (_videoControllers.containsKey(index)) {
      return;
    }

    final controller = VideoPlayerController.network(url);

    try {
      await controller.initialize().timeout(const Duration(seconds: 10));
      _videoControllers[index] = controller;
      if (index == _currentPage && mounted) {
        setState(() {});
      }
      controller.play();
      controller.setLooping(true);
    } catch (e) {
      // Handle timeout error or other errors
      print('Error loading video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: _videos.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _videos.length) {
            return _hasMore
                ? const Center(child: CircularProgressIndicator())
                : const Center(child: Text('No more videos.'));
          }
          return Stack(
            children: [
              VideoPlayerWidget(
                url: _videos[index],
                controller: _videoControllers[index],
              ),
            ],
          );
        },
      ),
    );
  }
}
