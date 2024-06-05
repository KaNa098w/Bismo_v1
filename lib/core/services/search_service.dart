import 'package:bismo/core/api_endpoints.dart';
import 'package:bismo/core/app_http.dart';
import 'package:bismo/core/models/catalog/goods.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:dio/dio.dart';

class SearchService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  Future<List<SearchResultItems>?> getGoods(String name) async {
    try {
      const url = ApiEndpoint.search;
      print('*** Request ***');
      print('uri: $url');
      print('method: POST');
      print('body: {"name": "$name"}');

      var res = await _http.post(url, data: {"name": name});

      if (res.statusCode == 200 || res.statusCode == 201) {
        SearchCatalogResponse response = SearchCatalogResponse.fromJson(res.data);
        return response.jSONBody;
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

  Future<GoodsResponse?> getFullPrice(String catId) async {
    final Dio dio = Dio();
    final String url = '${ApiEndpoint.getGoods}?login_provider=7757499451&cat_id=$catId';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        GoodsResponse goodsResponse = GoodsResponse.fromJson(response.data);
        return goodsResponse;
      } else {
        throw Exception('Failed to load full price. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching full price: $e');
      rethrow;
    }
  }
}
