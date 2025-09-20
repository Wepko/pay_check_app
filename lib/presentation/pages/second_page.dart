import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_check_app/controllers/receipt_controller.dart';
import 'package:pay_check_app/presentation/widgets/item_receipt_widget.dart';

class SecondPage extends StatelessWidget {
  final ReceiptController controller = Get.find<ReceiptController>();

  SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatCard(
                icon: Icons.receipt,
                title: 'Всего чеков',
                value: '${controller.receiptsCount}',
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                icon: Icons.attach_money,
                title: 'Общая сумма',
                value: '${controller.totalAmount.toStringAsFixed(2)} руб.',
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                icon: Icons.trending_up,
                title: 'Средний чек',
                value: '${controller.averageAmount.toStringAsFixed(2)} руб.',
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              const Text(
                'Детализация по чекам:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: controller.receipts.isEmpty
                    ? const Center(
                        child: Text(
                          'Нет данных для отображения',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.receipts.length,
                        itemBuilder: (context, index) {
                          final receipt = controller.receipts[index];
                          return ItemReceiptWidget(receipt: receipt);
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}