import 'package:get/get.dart';

import '../features/home/presentation/pages/home_screen.dart';
import '../features/home/presentation/pages/result_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String results = '/results';

  static final routes = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: results, page: () => const MapScreen()),
  ];
}
