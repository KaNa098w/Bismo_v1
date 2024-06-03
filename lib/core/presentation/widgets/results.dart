class Results {
  final String? name;
  final String? cateName;
  final int? quantity;

  Results({this.name, this.cateName, this.quantity});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      name: json['name'],
      cateName: json['cate_name'],
      quantity: json['quantity'],
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
