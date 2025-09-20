import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_check_app/controllers/receipt_controller.dart';
import 'package:pay_check_app/data/models/receipt_model.dart';

class ItemReceiptWidget extends StatelessWidget {
  const ItemReceiptWidget({
    super.key,
    required this.receipt,
  });

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<ReceiptController>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(
          Icons.receipt,
          color: Colors.blue,
        ),
        title: Text(receipt.title),
        subtitle: Text(
          '${receipt.amount.toStringAsFixed(2)} руб. • ${receipt.date.toString().substring(0, 10)}',
        ),
        trailing: Text(
          '${receipt.amount.toStringAsFixed(2)} руб.',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}