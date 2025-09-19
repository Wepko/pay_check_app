// utils/dialog_utils.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static void showDeleteConfirmationDialog({
    required String title,
    required String message,
    required Function() onConfirm,
    String confirmText = 'Удалить',
    String cancelText = 'Отмена',
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}