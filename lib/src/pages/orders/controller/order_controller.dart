import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/orders/orders_result/orders_result.dart';
import 'package:greengrocer/src/pages/orders/repository/orders_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class OrderController extends GetxController {
  OrderModel order;

  OrderController(this.order);

  final ordersRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utils = UtilsServices();
  bool isLoading = false;

  void setLoadind(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getOrderItems() async {
    setLoadind(true);

    final OrdersResult<List<CartItemModel>> result =
        await ordersRepository.getOrderItems(
      orderId: order.id,
      token: authController.user.token!,
    );

    setLoadind(false);

    result.when(
      success: (items) {
        order.items = items;
        update();
      },
      error: (message) {
        utils.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
