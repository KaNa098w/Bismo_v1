import 'package:flutter/material.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:bismo/core/services/search_service.dart';
import 'package:bismo/app/catalog/catalog_view.dart';
import 'package:bismo/app/catalog/goods/goods_view.dart' as mobile;
import 'package:dio/dio.dart';

class SearchCatalogView extends StatefulWidget {
  final String? title;
  final String query; // Добавляем параметр для запроса поиска

  const SearchCatalogView({Key? key, this.title, required this.query}) : super(key: key);

  @override
  State<SearchCatalogView> createState() => _SearchCatalogViewState();
}

class _SearchCatalogViewState extends State<SearchCatalogView> {
  final SearchService _searchService = SearchService();
  List<SearchResultItems>? _searchResults;
  bool _isLoadingResults = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults(widget.query); // Используем переданный поисковый запрос
  }

  Future<void> _fetchSearchResults(String query) async {
    try {
      final results = await _searchService.getGoods(query);
      setState(() {
        _searchResults = results;
        _isLoadingResults = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingResults = false;
      });
    }
  }

  Future<void> _fetchGroupDetails(String catId) async {
    final Dio dio = Dio();
    final String url = 'http://188.95.95.122:2223/server/hs/provider/getskygroup?User=7757499452&provider=7757499451&cat_id=$catId';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        print(response.data); // Обработка данных ответа
        // Добавьте здесь код для отображения данных категории
      }
    } catch (e) {
      print('Error fetching group details: $e');
    }
  }

  void _onSearchResultTap(SearchResultItems item) {
    if (item.group == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => mobile.GoodsView(
            title: item.name ?? '',
            catId: item.catId ?? '',
          ),
        ),
      );
    } else {
      _fetchGroupDetails(item.catId ?? ''); // Выполняем запрос с cat_id
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CatalogView(
            title: item.name ?? '',
            catId: item.catId ?? '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Результаты поиска'),
      ),
      body: _isLoadingResults
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _fetchSearchResults(widget.query), // Повторный запрос с использованием переданного параметра
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _searchResults == null || _searchResults!.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.separated(
                      itemCount: _searchResults!.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults![index];
                        return ListTile(
                          title: Text(item.name ?? 'No Name'),
                          subtitle: Text(item.cateName ?? 'No Category'),
                          trailing: item.group == false
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Количество: ${item.quantity ?? 0}'),
                                  ],
                                )
                              : const Icon(Icons.arrow_forward),
                          onTap: () => _onSearchResultTap(item), // Добавляем обработчик нажатия
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(), // Добавляем разделитель между элементами
                    ),
    );
  }
}
