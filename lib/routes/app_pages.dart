import 'package:get/get.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/receipt_details_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomePage(),
    ),
    GetPage(
      name: '/receipt/:id',
      page: () => ReceiptDetailPage(),
    ),
  ];
}