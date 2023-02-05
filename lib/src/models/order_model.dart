import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';

class OrderModel {
  String id;
  DateTime? createdAt;
  DateTime due; // Usar pra vê se o QRCode venceu
  @JsonKey(defaultValue: [])
  List<CartItemModel> items;
  String status;
  String copiaecola;
  String qrCodeImage;
  double total;

  bool get isOverDue => due.isBefore(DateTime.now());

  OrderModel({
    required this.id,
    this.createdAt,
    required this.due,
    required this.items,
    required this.status,
    required this.copiaecola,
    required this.qrCodeImage,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt!.millisecondsSinceEpoch});
    }
    result.addAll({'due': due.millisecondsSinceEpoch});
    result.addAll({'items': items.map((x) => x.toMap()).toList()});
    result.addAll({'status': status});
    result.addAll({'copiaecola': copiaecola});
    result.addAll({'qrCodeImage': qrCodeImage});
    result.addAll({'total': total});

    return result;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      due: DateTime.parse(map['due'] as String),
      items: (map['result'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      // items: List<CartItemModel>.from(
      //     map['items']?.map((x) => CartItemModel.fromMap(x))),
      status: map['status'] ?? '',
      copiaecola: map['copiaecola'] ?? '',
      qrCodeImage: map['qrCodeImage'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(id: $id, createdAt: $createdAt, due: $due, items: $items, status: $status, copiaecola: $copiaecola, qrCodeImage: $qrCodeImage, total: $total)';
  }
}
