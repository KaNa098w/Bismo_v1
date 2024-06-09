import 'dart:convert';
import 'package:bismo/core/presentation/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MediaDeleteView extends StatefulWidget {
  final String title;
  final String phone;
  final String code;

  const MediaDeleteView({Key? key, required this.title, required this.phone, required this.code}) : super(key: key);

  @override
  State<MediaDeleteView> createState() => _MediaDeleteViewState();
}

class _MediaDeleteViewState extends State<MediaDeleteView> {
  late Future<List<String>> _media;

  @override
  void initState() {
    super.initState();
    _media = fetchMedia(widget.phone, widget.code);
  }

  Future<List<String>> fetchMedia(String phone, String code) async {
    final response = await http.get(
      Uri.parse('http://86.107.45.59/api/images?phone=$phone&code=$code'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> media = data.map((item) => 'https://dulat.object.pscloud.io/$item').toList();
      return media;
    } else {
      throw Exception('Failed to load media');
    }
  }

  Future<void> deleteMedia(String mediaUrl) async {
    final mediaName = mediaUrl.split('/').last;
    final response = await http.delete(
      Uri.parse('http://86.107.45.59/api/images/?phone=${widget.phone}&code=${widget.code}&name=$mediaName'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _media = fetchMedia(widget.phone, widget.code);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Медиа удалено'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось удалить медиа'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool isVideo(String url) {
    return url.endsWith('.mp4') || url.endsWith('.mov') || url.endsWith('.avi');
  }

  void _confirmDelete(String mediaUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы точно хотите удалить этот файл?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteMedia(mediaUrl);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: _media,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No media found');
            } else {
              return Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final mediaUrl = snapshot.data![index];
                    return Column(
                      children: [
                        Expanded(
                          child: isVideo(mediaUrl)
                              ? VideoPlayerWidget(url: mediaUrl)
                              : Image.network(
                                  mediaUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image);
                                  },
                                ),
                        ),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _confirmDelete(mediaUrl);
                          },
                          label: const Text(
                            'Удалить файл',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
