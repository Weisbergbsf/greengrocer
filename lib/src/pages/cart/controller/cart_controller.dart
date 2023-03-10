import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/cart/cart_result/cart_result.dart';
import 'package:greengrocer/src/pages/cart/repository/cart_repository.dart';
import 'package:greengrocer/src/pages/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartController extends GetxController {
  final _cartRepository = CartRepository();
  final _authController = Get.find<AuthController>();
  final _utilsServices = UtilsServices();

  List<CartItemModel> cartItems = [];

  bool isCheckoutLoading = false;

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

  Future<bool> changeItemQuantity({
    required CartItemModel item,
    required int quantity,
  }) async {
    final result = await _cartRepository.changeItemQuantity(
      token: _authController.user.token!,
      cartItemId: item.id,
      quantity: quantity,
    );

    if (result) {
      if (quantity == 0) {
        cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      } else {
        cartItems.firstWhere((cartItem) => cartItem.id == item.id).quantity =
            quantity;
      }

      update();
    } else {
      _utilsServices.showToast(
        message: 'Ocorreu um erro ao alterar a quantidade do produto',
        isError: true,
      );
    }

    return result;
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

  int getCartTotalItems() {
    return cartItems.isEmpty
        ? 0
        : cartItems.map((e) => e.quantity).reduce((a, b) => a + b);
  }

  int getItemIndex(ItemModel product) {
    return cartItems
        .indexWhere((productInList) => productInList.product.id == product.id);
  }

  Future<void> addItemToCart(
      {required ItemModel product, int quantity = 1}) async {
    int productIndex = getItemIndex(product);

    if (productIndex >= 0) {
      final product = cartItems[productIndex];

      await changeItemQuantity(
          item: product, quantity: (product.quantity + quantity));
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

  void seCheckoutLoading(bool value) {
    isCheckoutLoading = value;
    update();
  }

  Future checkoutCart() async {
    seCheckoutLoading(true);

    CartResult<OrderModel> result = await _cartRepository.checkoutCart(
      token: _authController.user.token!,
      total: cartTotalPrice(),
    );

    seCheckoutLoading(false);

    result.when(
      success: (order) {
        cartItems.clear();
        update();

        showDialog(
          context: Get.context!,
          builder: (context) => PaymentDialog(order: order),
        );
      },
      error: (message) {
        _utilsServices.showToast(message: message);
      },
    );
  }
}
