import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  final String message;

  DioExceptions(this.message);

  factory DioExceptions.fromDioError(DioError error) {
    String errorMessage = 'Request failed';
    if (error.response != null) {
      errorMessage = error.response!.data.toString();
    } else {
      errorMessage = error.requestOptions.path;
    }

    String handleError(int? statusCode, dynamic error) {
      switch (statusCode) {
        case 400:
          return 'Bad request';
        case 404:
          return 'Сервис не найден! Просим повторить позже!';
        case 500:
          return 'Ведутся технические работы. Просим повторить позже!';
        case 401:
          return 'Unauthorized';
        default:
          return 'Упс! Что-то пошло не так';
      }
    }

    switch (error.type) {
      case DioErrorType.cancel:
        errorMessage = "Запрос к серверу API был отменен";
        break;
      case DioErrorType.connectionTimeout:
        errorMessage = "Тайм-аут соединения с сервером API";
        break;
      case DioErrorType.badCertificate:
        errorMessage = "Ошибка неверного сертификата";
        break;
      case DioErrorType.receiveTimeout:
        errorMessage = "Тайм-аут получения в связи с сервером API";
        break;
      case DioErrorType.badResponse:
        errorMessage =
            handleError(error.response?.statusCode, error.response?.data);
        break;
      case DioErrorType.sendTimeout:
        errorMessage = "Тайм-аут отправки в связи с сервером API";
        break;
      default:
        errorMessage = "Что-то пошло не так. Просим повторить позже!";
        break;
    }

    return DioExceptions(errorMessage);
  }

  @override
  String toString() {
    return message;
  }
}

class CustomException implements Exception {
  String cause;
  CustomException(this.cause);
}
