import 'dart:convert';
import 'dart:io';
import 'package:bismo/core/presentation/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
  int _currentPageLoading = -1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialVideos();
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

  Future<void> _fetchInitialVideos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<String> videos = await _fetchVideosFromApi(page: 1);
      setState(() {
        _videos = videos;
        _hasMore = videos.isNotEmpty;
        _isLoading = false;
      });

      // Предварительная загрузка первых двух видео
      if (_videos.isNotEmpty) {
        _loadVideoController(_videos[0], 0);
        if (_videos.length > 1) {
          _loadVideoController(_videos[1], 1);
        }
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onPageChanged() {
    int nextPage = _pageController.page!.round();
    if (nextPage != _currentPage) {
      setState(() {
        _currentPage = nextPage;
      });
      _loadSurroundingVideos(nextPage);
    }
  }

  Future<void> _fetchMoreVideos() async {
    if (_isLoading || !_hasMore || _currentPageLoading == _currentPage) return;

    setState(() {
      _currentPageLoading = _currentPage + 1;
    });

    try {
      final List<String> videos = await _fetchVideosFromApi(page: _currentPage + 1);
      setState(() {
        _videos.addAll(videos);
        _hasMore = videos.isNotEmpty;
      });

      // Предварительная загрузка текущего и следующих двух видео
      _loadSurroundingVideos(_currentPage);
    } catch (error) {
      // Handle error appropriately
    }
  }

  Future<void> _fetchPreviousVideos() async {
    if (_isLoading || _currentPageLoading == _currentPage) return;

    setState(() {
      _currentPageLoading = _currentPage;
    });

    try {
      final List<String> videos = await _fetchVideosFromApi(page: _currentPage - 1);
      setState(() {
        _videos.insertAll(0, videos);
        _hasMore = videos.isNotEmpty;
      });

      // Предварительная загрузка текущего и предыдущих двух видео
      _loadSurroundingVideos(_currentPage);
    } catch (error) {
      // Handle error appropriately
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
        final List<dynamic> videoList = videosData.values.expand((element) => element as List<dynamic>).toList();
        final List<String> videoUrls = [];

        for (var video in videoList) {
          final url = video['image_path'] as String;
          if (await _isValidVideoUrl(url)) {
            print('Valid video URL: $url');
            videoUrls.add(url);
          } else {
            print('Invalid video URL: $url');
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
      return response.statusCode == 200 && response.headers['content-type']?.startsWith('video/') == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadVideoController(String url, int index) async {
    if (!_videoControllers.containsKey(index)) {
      try {
        final file = await _downloadAndSaveFile(url, 'video_$index.mp4');
        final controller = VideoPlayerController.file(file);
        await controller.initialize();
        if (mounted) {
          setState(() {
            _videoControllers[index] = controller;
          });
        }
      } catch (e) {
        // Handle error if video file is not found or fails to download
        print('Error loading video controller for $url: $e');
      }
    }
  }

  Future<File> _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    } else {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download video');
      }
    }
  }

  void _loadSurroundingVideos(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_videos.isNotEmpty) {
        if (index < _videos.length) {
          _loadVideoController(_videos[index], index);
        }
        if (index + 1 < _videos.length) {
          _loadVideoController(_videos[index + 1], index + 1);
        }
        if (index + 2 < _videos.length) {
          _loadVideoController(_videos[index + 2], index + 2);
        }
        if (index - 1 >= 0) {
          _loadVideoController(_videos[index - 1], index - 1);
        }
        if (index - 2 >= 0) {
          _loadVideoController(_videos[index - 2], index - 2);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading && _videos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              scrollDirection: Axis.vertical, // Прокрутка по вертикали
              controller: _pageController,
              itemCount: _videos.length + 1,
              itemBuilder: (context, index) {
                if (index == _videos.length) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _fetchMoreVideos());
                  return const Center(child: CircularProgressIndicator());
                } else if (index == 0 && _currentPage == 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _fetchPreviousVideos());
                  return const Center(child: CircularProgressIndicator());
                }
                return VideoPlayerWidget(
                  url: _videos[index],
                  controller: _videoControllers[index],
                );
              },
            ),
    );
  }
}
