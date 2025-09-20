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
        title: Text(receipt.organizationName),
        subtitle: Text('${receipt.totalAmount.toStringAsFixed(2)} руб. • ${receipt.date.toString().substring(0, 10)}',
        ),
        trailing: Text(
          '${receipt.totalAmount.toStringAsFixed(2)} руб.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[400],
          ),
        ),
      ),
    );
  }
}