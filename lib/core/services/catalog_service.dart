import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/catalog/category.dart';
import 'package:dio/dio.dart';

class CatalogService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  final Map<String, CategoryResponse> _cache =
      {}; // Кэш для хранения данных по категориям

  Future<CategoryResponse?> getCategories(String catId) async {
    if (_cache.containsKey(catId) && _cache[catId] != null) {
      return _cache[catId];
    }

    try {
      Response res = await _http.get(ApiEndpoint.getCategories, params: {
        "User": '7757499452',
        'provider': '7757499451',
        "cat_id": catId
      });

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Десериализация ответа в объект CategoryResponse
        CategoryResponse response = CategoryResponse.fromJson(res.data);
        _cache[catId] = response; // Сохраняем ответ в кэше
        return response;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow; // Перебрасываем исключение для обработки на более высоком уровне
    }
  }
}
