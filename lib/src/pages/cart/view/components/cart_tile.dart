import 'package:flutter/material.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/pages/common_widgets/quantity_widget.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartTile extends StatefulWidget {
  final CartItemModel cartItem;

  const CartTile({super.key, required this.cartItem});

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final UtilsServices utils = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        // Imagem
        leading: Image.network(
          widget.cartItem.product.imgUrl,
          height: 60,
          width: 60,
        ),
        // Titulo
        title: Text(
          widget.cartItem.product.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        // Total
        subtitle: Text(
          utils.priceToCurrency(widget.cartItem.totalPrice()),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Quantidade
        trailing: QuantityWidget(
          suffixText: widget.cartItem.product.unit,
          value: widget.cartItem.quantity,
          result: (quantity) {
            setState(() {
              widget.cartItem.quantity = quantity;
            });
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
