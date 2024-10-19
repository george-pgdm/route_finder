import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/home/presentation/pages/home_screen.dart';

class Utility {
  static Placemark? startPoint;
  static Placemark? endPoint;
  static LatLng? currentLocation = const LatLng(8.524139, 76.936638);

  static Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      debugPrint('Location permission granted');
      // Proceed with your functionality
    } else if (status.isDenied) {
      debugPrint('Location permission denied');
      // Handle permission denied case
    } else if (status.isPermanentlyDenied) {
      debugPrint('Location permission permanently denied');
      // Open app settings to allow user to grant permission
      openAppSettings();
    }
  }
}
