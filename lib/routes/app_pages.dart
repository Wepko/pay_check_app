import 'package:get/get.dart';
import '../presentation/pages/receipt_list_page.dart';
import '../presentation/pages/receipt_details_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => ReceiptListPage(),
    ),
    GetPage(
      name: '/receipt/:id',
      page: () => ReceiptDetailPage(),
    ),
  ];
}