import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/receipt_controller.dart';

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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.receipt, color: Colors.blue),
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
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
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