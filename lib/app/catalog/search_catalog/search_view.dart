import 'package:flutter/material.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:bismo/core/services/search_service.dart';
import 'package:bismo/app/catalog/goods/goods_view.dart' as mobile;

class SearchCatalogView extends StatefulWidget {
  final String? title;
  final String query;

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
    _fetchSearchResults(widget.query);
  }

  Future<void> _fetchSearchResults(String query) async {
    try {
      final results = await _searchService.getGoods(query);
      setState(() {
        _searchResults = results;
        _isLoadingResults = false;
      });

      // Логирование данных для диагностики
      if (results != null) {
        for (var item in results) {
          print('Item: ${item.name}, cateId: ${item.cateId}, group: ${item.group}');
        }
      }

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingResults = false;
      });
    }
  }

  Future<void> _fetchGroupDetails(String catId) async {
    try {
      final response = await _searchService.getFullPrice(catId);
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => mobile.GoodsView(
              title: response.goods?.first.nomenklatura ?? '',
              catId: catId,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error fetching group details: $e');
    }
  }

  void _onSearchResultTap(SearchResultItems item) {
    final cateId = item.cateId ?? ''; // Использование cateId вместо catId
    print('Tapped item: ${item.name}, cateId: $cateId');
    print('Item details: $item'); // Логирование всего объекта для диагностики

    if (cateId.isNotEmpty) {
      if (item.group == false) {
        _fetchGroupDetails(cateId); // Выполняем запрос с cateId и переходим в GoodsView
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => mobile.GoodsView(
              title: item.name ?? '',
              catId: cateId, // Использование cateId вместо catId
            ),
          ),
        );
      }
    } else {
      print('Error: cateId is empty');
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
                          onPressed: () => _fetchSearchResults(widget.query),
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
                          onTap: () => _onSearchResultTap(item),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
    );
  }
}
