import 'package:get/get.dart';
import '../data/models/receipt_model.dart';
import '../data/repositories/receipt_repository.dart';

class ReceiptController extends GetxController {
  final ReceiptRepository _repository = ReceiptRepository();
  final receipts = <Receipt>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadReceipts();
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
}