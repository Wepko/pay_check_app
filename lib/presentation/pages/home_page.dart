import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/receipt_controller.dart';
import '../../data/models/receipt_model.dart';

class HomePage extends StatelessWidget {
  final ReceiptController controller = Get.find<ReceiptController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои чеки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddReceiptDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.receipts.isEmpty) {
          return const Center(child: Text('Нет чеков'));
        }

        return ListView.builder(
          itemCount: controller.receipts.length,
          itemBuilder: (context, index) {
            final receipt = controller.receipts[index];
            return ListTile(
              title: Text(receipt.title),
              subtitle: Text(
                  '${receipt.amount} руб. • ${receipt.date.toString().substring(0, 10)}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteReceipt(receipt.id!),
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddReceiptDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить чек'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Сумма'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final amount = double.tryParse(amountController.text) ?? 0;

                if (title.isNotEmpty && amount > 0) {
                  controller.addReceipt(Receipt(
                    title: title,
                    amount: amount,
                    date: DateTime.now(),
                  ));
                  Get.back();
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}