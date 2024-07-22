class SearchResults {
  final String? name;
  final String? cateName;
  final int? quantity;

  SearchResults({this.name, this.cateName, this.quantity});

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      name: json['name'],
      cateName: json['cate_name'],
     quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cate_name': cateName,
      'quantity': quantity,
    };
  }
}
