import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_check_app/controllers/receipt_controller.dart';
import 'package:pay_check_app/presentation/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ReceiptController receiptController = Get.put(ReceiptController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Receipt App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}