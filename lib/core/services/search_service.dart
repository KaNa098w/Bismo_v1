import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:dio/dio.dart';

import '../presentation/widgets/results.dart';

class SearchService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  Future<List<SearchResults>?> getGoods(String name) async {
    try {
      final url = '${ApiEndpoint.search}?name=${Uri.encodeComponent(name)}';
      print('*** Request ***');
      print('uri: $url');
      print('method: POST');

      var res = await _http.post(url);

   

      if (res.statusCode == 200 || res.statusCode == 201) {
        SearchCatalogResponse response = SearchCatalogResponse.fromJson(res.data);
        return response.jSONBody
            ?.map((jsonBody) => SearchResults.fromJson(jsonBody as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load data. Status code: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        throw Exception('Method Not Allowed: The server does not support the requested method.');
      }
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
