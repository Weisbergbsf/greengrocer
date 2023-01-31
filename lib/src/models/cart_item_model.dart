import 'dart:convert';

import 'package:greengrocer/src/models/item_model.dart';

class CartItemModel {
  String id;
  ItemModel product;
  int quantity;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  double totalPrice() => product.price * quantity;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'product': product.toMap()});
    result.addAll({'quantity': quantity});

    return result;
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] ?? '',
      product: ItemModel.fromMap(map['product']),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CartItemModel(id: $id, product: $product, quantity: $quantity)';
}
