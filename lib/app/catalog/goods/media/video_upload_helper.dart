import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<void> uploadVideo(BuildContext context, String phone, String nomenklaturaKod, String catId, VoidCallback onDialogClose, ValueChanged<String> onNewPhotoUrl) async {
  // Запрос разрешения на доступ к хранилищу
  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Открытие файлового менеджера и разрешение выбора только видеофайлов
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String? filePath = file.path;

      if (filePath != null) {
        File videoFile = File(filePath);

        // Заголовки для запроса
        Map<String, String> headers = {
          "Accept": "application/json",
          "X-XSRF-TOKEN": "your-xsrf-token", // Вы можете добавить ваш XSRF-токен здесь
        };

        // Создание запроса multipart
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://86.107.45.59/api/images/upload'),
        );

        request.headers.addAll(headers);
        request.files.add(await http.MultipartFile.fromPath('video[]', videoFile.path));

        // Добавление других данных формы
        request.fields['phone'] = phone;
        request.fields['nomenklaturaKod'] = nomenklaturaKod;

        // Отправка запроса
        var response = await request.send();

        // Обработка ответа
        if (response.statusCode == 200) {
          print('Видео успешно загружено');
          response.stream.transform(utf8.decoder).listen((value) {
            print(value);  // Это выведет ответ сервера, если он есть
            // Обновление URL изображения
            onNewPhotoUrl(value); // Используйте правильное значение из ответа сервера
          });
        } else {
          print('Ошибка при загрузке видео: ${response.statusCode}');
        }
      } else {
        print('Путь к файлу не найден');
      }
    } else {
      // Пользователь отменил выбор файла
      print('Файл не выбран');
    }
  } else {
    // Разрешение отклонено
    print('Доступ к хранилищу запрещен');
  }
}