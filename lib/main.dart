import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:route_finder/core/utils/utility.dart';
import 'package:route_finder/features/home/presentation/controllers/location_model.dart';

import 'core/resources/app_theme.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocationModelAdapter());
  // await Hive.openBox<LocationModel>('history');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    reqLocation();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  reqLocation() {
    Timer(
      const Duration(seconds: 3),
      () async {
        await Utility.requestLocationPermission().then((value) async {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          Utility.currentLocation =
              LatLng(position.latitude, position.longitude);
          debugPrint(
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}");

          if (mounted) {
            await Future.delayed(const Duration(milliseconds: 3000));

            Get.toNamed('/');
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
