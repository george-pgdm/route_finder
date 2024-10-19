import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:route_finder/core/utils/utility.dart';
import 'package:route_finder/core/widgets/app_custom_button.dart';
import 'package:route_finder/features/home/presentation/controllers/location_history_controller.dart';

import '../../../../core/resources/color_file.dart';
import '../../../../core/widgets/profile_card.dart';
import '../controllers/home_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final LocationHistoryController locController =
      Get.put(LocationHistoryController());
  final HomeController controller = Get.put(HomeController());

  List historyData = [];

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  getLocationData() {
    historyData = locController.locationHistory;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: size.height * 0.2, child: const ProfileCard()),
            historyData.isNotEmpty
                ? SizedBox(
                    height: size.height * 0.66,
                    child: ListView(
                      shrinkWrap: true,
                      children: List.generate(
                        historyData.length,
                        (index) {
                          final locationData = historyData[index];
                          return GestureDetector(
                            onTap: () {
                              Utility.requestLocationPermission()
                                  .then((value) async {
                                Get.toNamed('/results');
                              });
                            },
                            child:
                                cardLocationSearch("Trip $index", locationData),
                          );
                        },
                      ).toList(),
                    ),
                  )
                : const Center(
                    child: Text(
                      "No data found!!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
            Container(
                color: ColorFile.primaryColor,
                height: size.height * 0.1,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppCustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: "Go Back",
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget cardLocationSearch(String type, key) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 10),
      padding: const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
      height: 230,
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the card
        borderRadius: BorderRadius.circular(12), // Rounded corners
        border: Border.all(
          color: Colors.blue.withOpacity(0.3), // Border color
          width: 2, // Border width
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4), // Shadow position
            blurRadius: 8.0, // Shadow blur radius
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Image.asset(
                  "assets/images/location_ic.png",
                  height: 22,
                  width: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  key.startLatitude,
                  key.startLongitude,
                ),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Placemark {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  Placemark({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Placemark.fromJson(Map<String, dynamic> json) {
    // Extracting coordinates from the JSON response
    final coordinates = json['geometry']['coordinates'] as List;
    return Placemark(
      id: json['id'] ?? '',
      name: json['place_name'] ?? '',
      latitude: coordinates[1],
      longitude: coordinates[0],
    );
  }
}
