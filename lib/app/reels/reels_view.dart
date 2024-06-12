import 'package:bismo/core/presentation/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

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
    _cleanupOldCache();
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
      // Handle error
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

  Future<void> _cleanupOldCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheDir = await getTemporaryDirectory();
    final now = DateTime.now();

    prefs.getKeys().forEach((key) {
      final cachedTime = DateTime.parse(prefs.getString(key) ?? '');
      if (now.difference(cachedTime).inDays > 10) {
        final file = File('${cacheDir.path}/$key');
        if (file.existsSync()) {
          file.deleteSync();
        }
        prefs.remove(key);
      }
    });
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
                return FutureBuilder<String>(
                  future: _getCachedVideoPath(_videoUrls[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return VideoPlayerWidget(url: snapshot.data!);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
    );
  }

  Future<String> _getCachedVideoPath(String url) async {
    final cacheDir = await getTemporaryDirectory();
    final fileName = Uri.parse(url).pathSegments.last;
    final file = File('${cacheDir.path}/$fileName');

    if (await file.exists()) {
      return file.path;
    } else {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(fileName, DateTime.now().toIso8601String());
        return file.path;
      } else {
        throw Exception('Failed to load video');
      }
    }
  }
}
