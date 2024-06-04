import 'package:bismo/core/presentation/widgets/results.dart';
import 'package:flutter/material.dart';
import 'package:bismo/core/models/catalog/search.dart';
import 'package:bismo/core/services/search_service.dart';

class SearchCatalogView extends StatefulWidget {
  final String? title;
  const SearchCatalogView({Key? key, this.title}) : super(key: key);

  @override
  State<SearchCatalogView> createState() => _SearchCatalogViewState();
}

class _SearchCatalogViewState extends State<SearchCatalogView> {
  final SearchService _searchService = SearchService();
  List<SearchResults>? _searchResults;
  bool _isLoadingResults = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    try {
      final results = await _searchService.getGoods(widget.title ?? '');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Search Results'),
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
                          onPressed: _fetchSearchResults,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _searchResults == null || _searchResults!.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: _searchResults!.length,
                      itemBuilder: (context, index) {
                        final item = _searchResults![index];
                        return ListTile(
                          title: Text(item.name ?? 'No Name'),
                          subtitle: Text(item.cateName ?? 'No Category'),
                          trailing: Text('Quantity: ${item.quantity ?? 0}'),
                        );
                      },
                    ),
    );
  }
}
