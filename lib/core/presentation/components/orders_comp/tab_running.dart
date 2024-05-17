import 'package:flutter/material.dart';
import 'package:bismo/core/models/order/order_model.dart';
import 'package:bismo/core/presentation/components/orders_comp/dummy_order_status.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_details.dart';
import 'package:bismo/core/presentation/components/orders_comp/order_preview_tile.dart';

class RunningTab extends StatefulWidget {
  const RunningTab({Key? key}) : super(key: key);

  @override
  _RunningTabState createState() => _RunningTabState();
}

class _RunningTabState extends State<RunningTab> {
  List<Order> runningOrders = []; // Список текущих заказов

  @override
  void initState() {
    super.initState();
    fetchRunningOrders(); // Получение текущих заказов при инициализации
  }

  void fetchRunningOrders() {
    // Здесь должен быть код для получения текущих заказов
    // Возможно, вы уже имеете реализацию этого метода
    // Например, используя HTTP-запрос или другой способ получения данных
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: runningOrders.length,
      itemBuilder: (context, index) {
        // Отображение информации о каждом текущем заказе в списке
        Order currentOrder = runningOrders[index]; // Получаем текущий заказ из списка
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
