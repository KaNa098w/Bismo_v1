import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

Future<void> uploadVideo(BuildContext context, String nomenklaturaKod) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.video,
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    String? filePath = file.path;

    if (filePath != null) {
      File videoFile = File(filePath);

      Dio dio = Dio();

      // Заголовки для запроса
      Map<String, String> headers = {
        "Accept": "application/json",
        "X-XSRF-TOKEN":
            "your-xsrf-token", // Вы можете добавить ваш XSRF-токен здесь
      };

      FormData formData = FormData.fromMap({
        "phone": '7783734209',
        "code": nomenklaturaKod,
        "video[]":
            await MultipartFile.fromFile(videoFile.path, filename: file.name),
      });

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Expanded(child: Text('Загрузка... 0%')),
                ],
              ),
            );
          },
        );

        Response response = await dio.post(
          'http://86.107.45.59/api/images/upload',
          data: formData,
          options: Options(headers: headers),
          onSendProgress: (int sent, int total) {
            if (total != -1) {
              int progress = ((sent / total) * 100).toInt();
              Navigator.of(context).pop();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20),
                        Expanded(child: Text('Загрузка... $progress%')),
                      ],
                    ),
                  );
                },
              );
            }
          },
        );

        Navigator.of(context).pop(); // Закрытие диалога прогресса

        if (response.statusCode == 200) {
          print('Видео успешно загружено');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Видео успешно загружено'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          print('Ошибка при загрузке видео: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Ошибка при загрузке видео: ${response.statusCode}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Закрытие диалога прогресса
        print('Ошибка при загрузке видео: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при загрузке видео: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Путь к файлу не найден');
    }
  } else {
    // Пользователь отменил выбор файла
    print('Файл не выбран');
  }
}
