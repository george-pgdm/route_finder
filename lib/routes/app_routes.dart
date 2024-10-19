import 'package:get/get.dart';
import 'package:route_finder/features/home/presentation/pages/history_screen.dart';

import '../features/home/presentation/pages/home_screen.dart';
import '../features/home/presentation/pages/result_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String results = '/results';
  static const String history = '/history';

  static final routes = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: results, page: () => const MapScreen()),
    GetPage(name: results, page: () => const HistoryScreen()),
  ];
}
