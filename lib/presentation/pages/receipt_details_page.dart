import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_check_app/controllers/receipt_controller.dart';
import 'package:pay_check_app/data/models/receipt_model.dart';

class ReceiptDetailPage extends StatefulWidget {
  const ReceiptDetailPage({super.key});

  @override
  State<ReceiptDetailPage> createState() => _ReceiptDetailPageState();
}

class _ReceiptDetailPageState extends State<ReceiptDetailPage> {
  final ReceiptController controller = Get.find<ReceiptController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late Receipt _editableReceipt;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final String? receiptId = Get.parameters['id'];
    Receipt? receipt;

    if (receiptId != null) {
      receipt = controller.receipts.firstWhere(
        (r) => r.id.toString() == receiptId,
        orElse: () =>
            Receipt(organizationName: '', totalAmount: 0, date: DateTime.now()),
      );
    }

    if (receipt == null || receipt.id == null) {
      return;
    }

    _editableReceipt = Receipt(
      id: receipt.id,
      organizationName: receipt.organizationName,
      totalAmount: receipt.totalAmount,
      date: receipt.date,
    );

    _titleController = TextEditingController(text: receipt.organizationName);
    _amountController = TextEditingController(
      text: receipt.totalAmount.toString(),
    );
    _selectedDate = receipt.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedReceipt = Receipt(
        id: _editableReceipt.id,
        organizationName: _titleController.text,
        totalAmount: double.parse(_amountController.text),
        date: _selectedDate,
      );

      controller.updateReceipt(updatedReceipt);
      setState(() {
        _isEditing = false;
      });
      Get.snackbar('Успех', 'Чек обновлен');
    }
  }

  void _deleteReceipt() {
    if (_editableReceipt.id != null) {
      _showDeleteConfirmationDialog();
    }
  }

  // Добавьте новый метод для показа диалога:
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text(
            'Вы уверены, что хотите удалить этот чек? Это действие нельзя отменить.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Закрыть диалог
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
                _performDelete(); // Выполнить удаление
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Метод для выполнения удаления
  void _performDelete() {
    if (_editableReceipt.id != null) {
      controller.deleteReceipt(_editableReceipt.id!);
      Get.back(); // Вернуться на предыдущий экран
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? receiptId = Get.parameters['id'];
    Receipt? receipt;

    if (receiptId != null) {
      receipt = controller.receipts.firstWhere(
        (r) => r.id.toString() == receiptId,
        orElse: () =>
            Receipt(organizationName: '', totalAmount: 0, date: DateTime.now()),
      );
    }

    if (receipt == null || receipt.id == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Чек не найден'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(child: Text('Чек не найден или был удален')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Редактирование чека2'
              : 'Чек: ${receipt.organizationName}',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.menu_book),
              onPressed: () => setState(() => _isEditing = false),
            ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteReceipt,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isEditing ? _buildEditForm() : _buildViewDetails(receipt),
      ),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              onPressed: _saveChanges,
              child: const Icon(Icons.save),
            )
          : null,
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Название чека',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите название чека';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Сумма',
              border: OutlineInputBorder(),
              prefixText: '₽ ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите сумму';
              }
              if (double.tryParse(value) == null) {
                return 'Введите корректную сумму';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Дата',
                border: OutlineInputBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDate(_selectedDate)),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewDetails(Receipt receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildDetailItem('Название', receipt.organizationName),
        // _buildDetailItem(
        //   'Сумма',
        //   '${receipt.totalAmount.toStringAsFixed(2)} руб.',
        // ),
        // _buildDetailItem('Дата', _formatDate(receipt.date)),
        // _buildDetailItem('ID', receipt.id.toString()),
        const SizedBox(height: 20),
        _buildStatCard(
          icon: Icons.qr_code_2,
          title: 'Дата создания',
          value: _formatDateTime(receipt.date),
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "ООО Пекарня",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Адрес: Самара. Советская Армии 148а",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "КАССОВЫЙ ЧЕК",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),

            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
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
                ),
                Icon(icon, size: 114, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
