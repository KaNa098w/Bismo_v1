import 'package:flutter/material.dart';
import 'package:bismo/core/models/order/order_model.dart';
import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_preview_tile.dart';

class CompletedTab extends StatefulWidget {
  const CompletedTab({Key? key}) : super(key: key);

  @override
  _CompletedTabState createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  List<Order> completedOrders = []; // Список завершенных заказов

  @override
  void initState() {
    super.initState();
    fetchCompletedOrders(); // Получение завершенных заказов при инициализации
  }

  void fetchCompletedOrders() {
    // Здесь должен быть код для получения завершенных заказов
    // Возможно, вы уже имеете реализацию этого метода
    // Например, используя HTTP-запрос или другой способ получения данных
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: completedOrders.length,
      itemBuilder: (context, index) {
        // Отображение информации о каждом завершенном заказе в списке
        Order currentOrder = completedOrders[index]; // Получаем текущий заказ из списка
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
