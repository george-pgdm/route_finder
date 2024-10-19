import 'package:locaview/features/home/presentation/controllers/location_model.dart';

import '../services/hive_services.dart';

class LocationHistoryRepository {
  Future<void> addLocationHistory(LocationModel history) async {
    await HiveService.addLocationHistory(history);
  }

  Future<List<LocationModel>> getAllLocationHistory() async {
    return await HiveService.getAllLocationHistory();
  }

  Future<void> removeLocationHistory(String id) async {
    await HiveService.removeLocationHistory(id);
  }
}
