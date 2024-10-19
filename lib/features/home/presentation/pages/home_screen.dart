import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:locaview/core/widgets/app_custom_button.dart';
import 'package:locaview/core/widgets/profile_card.dart';
import 'package:locaview/features/home/presentation/controllers/location_history_controller.dart';
import 'package:locaview/features/home/presentation/pages/history_screen.dart';
import 'package:locaview/features/home/presentation/pages/result_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/resources/color_file.dart';
import '../../../../core/utils/utility.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationHistoryController locController =
      Get.put(LocationHistoryController());
  final HomeController controller = Get.put(HomeController());
  GlobalKey<FormState> startKey = GlobalKey();
  GlobalKey<FormState> endKey = GlobalKey();
  final String accessToken =
      'sk.eyJ1IjoiYWtoaWxsZXZha3VtYXIiLCJhIjoiY2x4MDcxM3JlMGM5YTJxc2Q1cHc4MHkyZSJ9.awWNy5HErR8ooOddFDR6Gg';
  String searchQuery = '';
  List<Placemark> locations = [];

  List historyData = [];

  late final Box historyBox;

  bool isHome = true;

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
            // buildUserInfoWidget(size),
            SizedBox(height: size.height * 0.2, child: const ProfileCard()),
            SizedBox(
              height: size.height * 0.65,
              child: ListView(
                shrinkWrap: true,
                children: [
                  cardLocationSearch(
                      "Start Location", startKey, sMapController),
                  cardLocationSearch("End Location", endKey, eMapController),
                ],
              ),
            ),
            buildBottomContainer(size, context)
          ],
        ),
      ),
    );
  }

  Container buildBottomContainer(Size size, BuildContext context) {
    return Container(
        color: ColorFile.primaryColor,
        height: size.height * 0.1,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppCustomButton(
              text: 'Navigate',
              onPressed: () {
                if (Utility.startPoint == null) {
                  toast("Please select the Start Location");
                } else if (Utility.endPoint == null) {
                  toast("Please select the End Location");
                } else {
                  // controller.navigateToResults;
                  Utility.requestLocationPermission().then((value) async {
                    Get.toNamed('/results');
                  });
                }
              },
            ),
            AppCustomButton(
              text: 'Saved',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const HistoryScreen();
                  },
                ));
              },
            )
          ],
        ));
  }

  Container buildUserInfoWidget(Size size) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.bottomLeft,
      height: size.height * 0.2,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(21),
          bottomRight: Radius.circular(21),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4), // Shadow position
            blurRadius: 8.0, // Shadow blur radius
          ),
        ],
        color: ColorFile.primaryColor,
        // gradient: LinearGradient(
        //   colors: [
        //     ColorFile.primaryColor, // Start color
        //     Colors.white, // End color
        //   ],
        //   begin: Alignment.centerLeft, // Start point of the gradient
        //   end: Alignment.topCenter, // End point of the gradient
        //   tileMode: TileMode.mirror,
        // ),
      ),
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Image.asset(
                "assets/images/user_pic.png",
                height: 45,
                width: 45,
                color: ColorFile.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Robert Doe",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "robertdoe@gmail.com",
                  style: TextStyle(
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  MapController sMapController = MapController();
  MapController eMapController = MapController();
  Widget cardLocationSearch(String type, key, MapController mapController) {
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
          Row(
            children: [
              Image.asset(
                "assets/images/location_ic.png",
                height: 22,
                width: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                key: key,
                child: Autocomplete<Placemark>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Placemark>.empty();
                    }
                    searchLocation(textEditingValue.text);
                    return locations.toList();
                  },
                  displayStringForOption: (Placemark option) => option.name,
                  onSelected: (Placemark selection) {
                    // Handle the selection
                    debugPrint('Selected: ${selection.name}');
                    if (type == "Start Location") {
                      Utility.startPoint = Placemark(
                          id: selection.id,
                          name: selection.name,
                          latitude: selection.latitude,
                          longitude: selection.longitude);
                      sMapController.move(
                          LatLng(selection.latitude, selection.longitude), 17);
                    } else {
                      Utility.endPoint = Placemark(
                          id: selection.id,
                          name: selection.name,
                          latitude: selection.latitude,
                          longitude: selection.longitude);
                      eMapController.move(
                          LatLng(selection.latitude, selection.longitude), 17);
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          hintText: type,
                          border: InputBorder.none,
                          hintStyle: const TextStyle(color: Colors.black54)
                          // border: OutlineInputBorder(),
                          ),
                      style: const TextStyle(color: Colors.black),
                    );
                  },
                  optionsViewBuilder:
                      (context, onSelected, Iterable<Placemark> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final Placemark option = options.elementAt(index);
                            return ListTile(
                              title: Text(
                                option.name,
                                style: const TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Image.asset(
          //   "assets/images/dummy_map.jpg",
          //   width: double.infinity,
          //   height: 120,
          //   fit: BoxFit.cover,
          // ),
          SizedBox(
            height: 120,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: setInitLocation(type),
                initialZoom: 17,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(markers: [
                  if (Utility.startPoint != null)
                    Marker(
                      point: LatLng(
                        Utility.startPoint!.latitude,
                        Utility.startPoint!.longitude,
                      ),
                      child: const Icon(
                        Icons.center_focus_strong,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                  if (Utility.endPoint != null)
                    Marker(
                      point: LatLng(
                        Utility.endPoint!.latitude,
                        Utility.endPoint!.longitude,
                      ),
                      child: const Icon(
                        Icons.center_focus_strong,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }

  LatLng setInitLocation(String type) {
    if (Utility.startPoint == null) {
      return Utility.currentLocation!;
    } else if (Utility.endPoint == null) {
      return LatLng(Utility.currentLocation!.latitude,
          Utility.currentLocation!.longitude);
    } else {
      return LatLng(
        type == "Start Location"
            ? (Utility.startPoint?.latitude ??
                Utility.currentLocation!.latitude)
            : (Utility.endPoint?.latitude ?? Utility.currentLocation!.latitude),
        type == "Start Location"
            ? (Utility.startPoint?.longitude ??
                Utility.currentLocation!.longitude)
            : (Utility.endPoint?.longitude ??
                Utility.currentLocation!.longitude),
      );
    }
  }

  Widget cardHistory(String type, locationData) {
    return Card(
      margin: const EdgeInsets.all(10),
      shadowColor: ColorFile.primaryColor,
      color: Colors.white,
      elevation: 1,
      surfaceTintColor: Colors.grey,
      child: Container(
        height: 200,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/location_ic.png",
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  type,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                )
              ],
            ),
            const SizedBox(
                height: 10), // Adjusted to create space for the dropdown
            Image.asset(
              "assets/images/dummy_map.jpg",
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  void searchLocation(String query) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?country=IN&access_token=$accessToken';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        locations = (data['features'] as List)
            .map((feature) => Placemark.fromJson(feature))
            .toList();
      });
      debugPrint("Location length ${locations.length}");
    } else {
      throw Exception('Failed to load locations');
    }
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
