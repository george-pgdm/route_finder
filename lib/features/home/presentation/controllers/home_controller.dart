import 'package:get/get.dart';
import 'package:locaview/features/home/presentation/controllers/location_history_controller.dart';
import 'package:locaview/features/home/presentation/controllers/location_model.dart';

class HomeController extends GetxController {
  final LocationHistoryController _locationHistoryController = Get.find();

  Future<void> addLocationToHistory(String startName, String endName, String id,
      double startLat, double startLong, double endLat, double endLong) async {
    final history = LocationModel(
        startName: startName,
        endName: endName,
        id: id,
        startLatitude: startLat,
        startLongitude: startLong,
        endLatitude: endLat,
        endLongitude: endLong);

    await _locationHistoryController.addLocationHistory(history);
  }

  void navigateToResults() {
    Get.toNamed('/results');
  }

  void goToSavedSearches() {
    // Navigate to the history screen (implement this route as needed)
  }
}
