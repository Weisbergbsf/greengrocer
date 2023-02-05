import 'package:greengrocer/src/constants/endpoints.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/orders/orders_result/orders_result.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class OrdersRepository {
  final _httpManager = HttpManager();

  Future getOrderItems({required String orderId, required String token}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getOrderItems,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'orderId': orderId,
      },
    );

    if (result.containsKey('result')) {
      List<CartItemModel> items =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromMap)
              .toList();

      return OrdersResult<List<CartItemModel>>.success(items);
    } else {
      return OrdersResult.error(
          'Não foi possível recuperar os produtos do pedido');
    }
  }

  Future<OrdersResult<List<OrderModel>>> getAllOrders({
    required String userId,
    required String token,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllOrders,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        },
        body: {
          'user': userId
        });

    if (result.containsKey('result')) {
      List<OrderModel> orders =
          List<Map<String, dynamic>>.from(result['result'])
              .map(OrderModel.fromMap)
              .toList();

      return OrdersResult<List<OrderModel>>.success(orders);
    } else {
      return OrdersResult.error('Náo foi possível recuperar os pedidos');
    }
  }
}
