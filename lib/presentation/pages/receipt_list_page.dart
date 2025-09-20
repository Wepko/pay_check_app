import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_check_app/controllers/receipt_controller.dart';
import 'package:pay_check_app/data/models/receipt_model.dart';
import 'package:pay_check_app/presentation/widgets/dialog_widget.dart';

class ReceiptListPage extends StatelessWidget {
  final ReceiptController controller = Get.find<ReceiptController>();

  ReceiptListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои чеки'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
            return ItemReceiptOldWidget(receipt: receipt);
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
                  controller.addReceipt(
                    Receipt(organizationName: title, totalAmount: amount, date: DateTime.now()),
                  );
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

//Todo: Вынести в widget будет монокомпонент
class ItemReceiptOldWidget extends StatelessWidget {
  const ItemReceiptOldWidget({
    super.key,
    required this.receipt,
    this.onDelete,
    this.onTap,
  });

  final Receipt receipt;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ReceiptController controller = Get.find<ReceiptController>();

    return ListTile(
      leading: const Icon(Icons.receipt, color: Colors.blue),
      title: Text(receipt.organizationName),
      subtitle: Row(
        children: [
          Text(
            '${receipt.totalAmount} руб.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[400],
            ),
          ),
          Text(' • '),
          Text('${receipt.date.toString().substring(0, 10)}.'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => DialogWidget.showDeleteConfirmationDialog(
          title: 'Подтверждение удаления',
          message: 'Вы уверены, что хотите удалить этот чек?',
          onConfirm:
              onDelete ??
              () {
                if (receipt.id != null) {
                  controller.deleteReceipt(receipt.id!);
                }
              },
        ),
      ),
      onTap:
          onTap ??
          () {
            // Навигация к деталям чека используя именованный маршрут
            Get.toNamed('/receipt/${receipt.id}');
          },
    );
  }
}
