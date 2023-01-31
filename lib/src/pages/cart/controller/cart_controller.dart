import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/cart/cart_result/cart_result.dart';
import 'package:greengrocer/src/pages/cart/repository/cart_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartController extends GetxController {
  final _cartRepository = CartRepository();
  final _authController = Get.find<AuthController>();
  final _utilsServices = UtilsServices();

  List<CartItemModel> cartItems = [];

  @override
  void onInit() {
    super.onInit();

    getCartItems();
  }

  double cartTotalPrice() {
    double total = 0;

    for (final item in cartItems) {
      total += item.totalPrice();
    }
    return total;
  }

  Future<void> getCartItems() async {
    final CartResult<List<CartItemModel>> result =
        await _cartRepository.getCartItems(
      token: _authController.user.token!,
      userId: _authController.user.id!,
    );

    result.when(
      success: (data) {
        cartItems = data;
        update();
      },
      error: (message) {
        _utilsServices.showToast(message: message, isError: true);
      },
    );
  }

  int getItemIndex(ItemModel product) {
    return cartItems
        .indexWhere((productInList) => productInList.id == product.id);
  }

  Future<void> addItemToCart(
      {required ItemModel product, int quantity = 1}) async {
    int productIndex = getItemIndex(product);

    if (productIndex >= 0) {
      cartItems[productIndex].quantity += quantity;
    } else {
      final CartResult<String> result = await _cartRepository.addItemToCart(
        userId: _authController.user.id!,
        token: _authController.user.token!,
        productId: product.id,
        quantity: quantity,
      );

      result.when(
        success: (cartItemId) {
          cartItems.add(
            CartItemModel(
              id: cartItemId,
              product: product,
              quantity: quantity,
            ),
          );
        },
        error: (message) {
          _utilsServices.showToast(message: message, isError: true);
        },
      );
    }
    update();
  }
}
