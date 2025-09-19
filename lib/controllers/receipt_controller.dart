import 'package:get/get.dart';
import '../data/models/receipt_model.dart';
import '../data/repositories/receipt_repository.dart';

class ReceiptController extends GetxController {
  final ReceiptRepository _repository = ReceiptRepository();
  final receipts = <Receipt>[].obs;
  final isLoading = true.obs;
  final currentIndex = 0.obs; // Добавляем управление индексом навигации

  @override
  void onInit() {
    super.onInit();
    loadReceipts();
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> updateReceipt(Receipt receipt) async {
    try {
      await _repository.updateReceipt(receipt);
      await loadReceipts();
      Get.snackbar('Успех', 'Чек обновлен');
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось обновить чек');
    }
  }

  Future<void> loadReceipts() async {
    try {
      isLoading.value = true;
      final receiptsList = await _repository.getAllReceipts();
      receipts.assignAll(receiptsList);
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось загрузить чеки');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addReceipt(Receipt receipt) async {
    try {
      await _repository.insertReceipt(receipt);
      await loadReceipts();
      Get.snackbar('Успех', 'Чек добавлен');
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось добавить чек');
    }
  }

  Future<void> deleteReceipt(int id) async {
    try {
      await _repository.deleteReceipt(id);
      await loadReceipts();
      Get.snackbar('Успех', 'Чек удален');
    } catch (e) {
      Get.snackbar('Ошибка', 'Не удалось удалить чек');
    }
  }

  // Метод для статистики (используется на SecondPage)
  double get totalAmount {
    return receipts.fold(0, (sum, receipt) => sum + receipt.amount);
  }

  int get receiptsCount {
    return receipts.length;
  }

  double get averageAmount {
    return receiptsCount > 0 ? totalAmount / receiptsCount : 0;
  }
}