class Order {
  final String orderID;
  final String date;
  final String status;

  Order({
    required this.orderID,
    required this.date,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderID: json['number'] ?? "",
      date: json['date_loading'] ?? "",
      status: _getStatus(json['status']),
    );
  }

  static String _getStatus(int status) {
    switch (status) {
      case 0:
        return 'confirmed';
      case 1:
        return 'processing';
      case 2:
        return 'shipped';
      case 3:
        return 'delivery';
      case 4:
        return 'cancelled';
      default:
        return 'unknown';
    }
  }
}
