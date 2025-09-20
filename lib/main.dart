import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay_check_app/controllers/receipt_controller.dart';
import 'package:pay_check_app/presentation/pages/receipt_list_page.dart';
import 'package:pay_check_app/presentation/pages/info_page.dart';
import 'package:pay_check_app/presentation/pages/second_page.dart';
import 'package:pay_check_app/routes/app_pages.dart';

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
        useMaterial3: true,
      ),
      getPages: AppPages.routes,
      home: MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatelessWidget {
  final ReceiptController controller = Get.find<ReceiptController>();

  MainNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children:  [
          ReceiptListPage(),
          SecondPage(),
          InfoPage(),
        ],
      )),
      bottomNavigationBar: Obx(() => NavigationBar(
        selectedIndex: controller.currentIndex.value,
        onDestinationSelected: (index) {
          controller.changePage(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt),
            label: 'Чеки',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Статистика',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.info),
          //   label: 'О приложение',
          // ),
        ],
      )),
    );
  }
}