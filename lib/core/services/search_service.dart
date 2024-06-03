import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:bismo/core/presentation/widgets/results.dart';
import 'package:dio/dio.dart';

class SearchService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<List<Results>?> getGoods(String name) async {
    try {
      var encodedName = Uri.encodeQueryComponent(name); // Кодируем параметр запроса
      var res = await _http.get(ApiEndpoint.search, params: {'name': encodedName});

      if (res.statusCode == 200 || res.statusCode == 201) {
        SearchCatalogResponse response = SearchCatalogResponse.fromJson(res.data);
        return response.jSONBody
            ?.map((jsonBody) => Results.fromJson(jsonBody as Map<String, dynamic>))
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
