import 'package:get/get.dart';
import 'package:locaview/features/home/presentation/controllers/location_model.dart';

import '../../data/services/hive_services.dart';

class LocationHistoryController extends GetxController {
  final List<LocationModel> _locationHistory = [];
  List<LocationModel> get locationHistory => _locationHistory;

  @override
  void onInit() async {
    super.onInit();
    await HiveService.openBox();
    _loadLocationHistory();
  }

  Future<void> _loadLocationHistory() async {
    final historyList = await HiveService.getAllLocationHistory();
    _locationHistory.assignAll(historyList);
    update();
  }

  Future<void> addLocationHistory(LocationModel history) async {
    await HiveService.addLocationHistory(history);
    _loadLocationHistory();
  }

  Future<void> removeLocationHistory(String id) async {
    await HiveService.removeLocationHistory(id);
    _loadLocationHistory();
  }

  @override
  void onClose() {
    HiveService.closeBox();
    super.onClose();
  }
}
