import 'package:get/get.dart';
import '../presentation/pages/home_page.dart';


class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomePage(),
    ),
  ];
}