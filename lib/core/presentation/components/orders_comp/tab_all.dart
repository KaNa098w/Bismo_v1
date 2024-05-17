import 'dart:convert';
import 'package:bismo/core/models/order/order_model.dart';
import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AllTab extends StatefulWidget {
  const AllTab({Key? key}) : super(key: key);

  @override
  _AllTabState createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  List<Order> orders = []; // Список заказов

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Загрузка заказов при инициализации виджета
  }

  // Метод для выполнения запроса и получения данных о заказах
void fetchOrders() async {
  var headers = {
    'Authorization': 'Basic d2ViOjc3NTc0OTk0NTFEbA=='
  };

  var dio = Dio();
  try {
    var response = await dio.get(
      'http://api.bismo.kz/server/hs/product/detalizationsorder?UID=394c7334-d34e-4c04-b2cf-264c25d7391b&user=7777017100',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      // Проверка типа данных ответа
      if (response.data is Map<String, dynamic>) {
        // Получение списка заказов из данных ответа
        List<Order> fetchedOrders = [];
        for (var orderData in (response.data['orders'] as List<dynamic>)) {
          Order order = Order.fromJson(orderData);
          fetchedOrders.add(order);
        }
        // Обновление состояния, чтобы перестроить UI с полученными заказами
        setState(() {
          orders = fetchedOrders;
        });
      } else {
        print('Invalid data format: ${response.data}');
      }
    } else {
      print('Failed to load orders: ${response.statusMessage}');
    }
  } catch (e) {
    print('Error fetching orders: $e');
  }
}



  @override
  Widget build(BuildContext context) {
  return ListView.builder(
    padding: const EdgeInsets.only(top: 8),
    itemCount: orders.length,
    itemBuilder: (context, index) {
      // Отображение информации о каждом заказе в списке
      Order currentOrder = orders[index]; // Получаем текущий заказ из списка
      return OrderPreviewTile(
        order: currentOrder,
        onTap: () {
          // Переход на страницу с деталями заказа при нажатии на него
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(order: currentOrder),
            ),
          );
        },
        orderID: currentOrder.orderID, // Передаем orderID текущего заказа
        date: currentOrder.date, // Передаем date текущего заказа
        status: _getStatus(currentOrder.status as int), // Получаем объект OrderStatus для текущего заказа
      );
    },
  );
}

OrderStatus _getStatus(int status) {
  switch (status) {
    case 0:
      return OrderStatus.confirmed;
    case 1:
      return OrderStatus.processing;
    case 2:
      return OrderStatus.shipped;
    case 3:
      return OrderStatus.delivery;
    case 4:
      return OrderStatus.cancelled;
    default:
      return OrderStatus.unknown;
  }
}


}
