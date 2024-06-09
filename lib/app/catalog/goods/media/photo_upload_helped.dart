import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';

// Функция для отображения загрузчика
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Загрузка..."),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> uploadPhoto(BuildContext context, String phoneNumber, String nomenklaturaKod, String catId, Function onSuccess, Function updatePhotoUrl) async {
  // Запрашиваем разрешение на доступ к хранилищу
  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Открываем файловый менеджер и разрешаем выбирать только изображения
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String? filePath = file.path;

      if (filePath != null) {
        File photoFile = File(filePath);

        try {
          // Показать загрузчик
          showLoadingDialog(context);

          // Создание Dio instance
          Dio dio = Dio();

          // Создание FormData
          FormData formData = FormData.fromMap({
            'image[]': await MultipartFile.fromFile(photoFile.path, filename: '$phoneNumber/$nomenklaturaKod/1.png'),
            'phone': phoneNumber,
            'code': nomenklaturaKod,
          });

          // Заголовки для запроса
          Options options = Options(
            headers: {
              "Accept": "application/json",
              "X-XSRF-TOKEN": "your-xsrf-token", // Добавьте ваш XSRF-токен здесь
            },
          );

          // Выполнение POST запроса
          Response response = await dio.post(
            'http://86.107.45.59/api/images/upload',
            data: formData,
            options: options,
          );

          // Закрыть загрузчик
          Navigator.of(context, rootNavigator: true).pop();

          // Обработка ответа
          if (response.statusCode == 200 || response.statusCode == 201) {
            print('Фото успешно загружено');
            print(response.data);  // Вывод ответа сервера

            // Обновить URL фото
            updatePhotoUrl('$phoneNumber/$nomenklaturaKod/1.png');

            // Вызов колбэка для обновления данных
            onSuccess();
          } else {
            print('Ошибка при загрузке фото: ${response.statusCode}');
          }
        } catch (e) {
          // Закрыть загрузчик
          Navigator.of(context, rootNavigator: true).pop();
          print('Ошибка: $e');
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
    print('Доступ к хранилищу отклонен');
  }
}

// Предполагаемая функция для обновления данных на странице
Future<void> _fetchGoods(String catId) async {
  // Ваш код для обновления данных
}
