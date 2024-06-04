import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:dio/dio.dart';

import '../presentation/widgets/results.dart';

class SearchService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<List<SearchResults>?> getGoods(String name) async {
    try {
      // Формируем URL вручную, чтобы исключить кодирование
      final url = '${ApiEndpoint.search}?name=$name';
      print('Request URL: $url'); // Отладочное сообщение для проверки
      var res = await _http.get(url);

      if (res.statusCode == 200 || res.statusCode == 201) {
        SearchCatalogResponse response = SearchCatalogResponse.fromJson(res.data);
        return response.jSONBody
            ?.map((jsonBody) => SearchResults.fromJson(jsonBody as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load data. Status code: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        throw Exception('Server error: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
