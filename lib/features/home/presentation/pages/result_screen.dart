import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:get/get.dart';
import 'package:locaview/core/utils/utility.dart';

import '../../../../core/resources/color_file.dart';
import '../../../../core/widgets/app_custom_button.dart';
import '../controllers/home_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final HomeController controller = Get.put(HomeController());
  String? _platformVersion;
  String? _instruction;
  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  late MapBoxOptions _navigationOption;
  List<WayPoint> wayPoints = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    wayPoints = <WayPoint>[
      WayPoint(
        name: Utility.startPoint!.name.split(",").first,
        latitude: Utility.startPoint!.latitude,
        longitude: Utility.startPoint!.longitude,
      ),
      WayPoint(
        name: Utility.endPoint!.name.split(",").first,
        latitude: Utility.endPoint!.latitude,
        longitude: Utility.endPoint!.longitude,
      ),
    ];

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    _navigationOption.mapStyleUrlNight = "mapbox://styles/mapbox/streets-v11";
    _navigationOption.mapStyleUrlDay = "mapbox://styles/mapbox/streets-v11";
    _navigationOption.language = "en";
    _navigationOption.initialLatitude = Utility.startPoint!.latitude;
    _navigationOption.initialLongitude = Utility.startPoint!.longitude;

    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            height: size.height * 0.4,
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
            ),
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "YOUR LOCATION",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    Utility.startPoint!.name.split(",").first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/location_ic.png",
                        height: 15,
                        width: 15,
                        color: Colors.white,
                      ),
                      Text(
                        "${Utility.startPoint!.latitude}, ${Utility.startPoint!.longitude}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    color: Colors.white,
                  ),
                  Text(
                    Utility.endPoint!.name.split(",").first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/location_ic.png",
                        height: 15,
                        width: 15,
                        color: Colors.white,
                      ),
                      Text(
                        "${Utility.endPoint!.latitude}, ${Utility.endPoint!.longitude}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.navigation_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                      Text(
                        _durationRemaining != null
                            ? "${(_durationRemaining! / 60).toStringAsFixed(0)} minutes"
                            : "---",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 12, right: 12),
              child: Container(
                color: Colors.grey,
                child: MapBoxNavigationView(
                    options: _navigationOption,
                    onRouteEvent: _onEmbeddedRouteEvent,
                    onCreated:
                        (MapBoxNavigationViewController controller) async {
                      _controller = controller;
                      controller.initialize();

                      await controller.buildRoute(
                        wayPoints: wayPoints,
                        options: _navigationOption,
                      );
                    }),
              ),
            ),
          ),
          Container(
            color: ColorFile.primaryColor,
            height: size.height * 0.08,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppCustomButton(
                  onPressed: () {
                    controller.addLocationToHistory(
                      Utility.startPoint!.name,
                      Utility.endPoint!.name,
                      Utility.startPoint!.id,
                      Utility.startPoint!.latitude,
                      Utility.startPoint!.longitude,
                      Utility.endPoint!.latitude,
                      Utility.endPoint!.longitude,
                    );

                    Navigator.pop(context);
                  },
                  text: "Save",
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    if (_isNavigating) {
      _distanceRemaining =
          await MapBoxNavigation.instance.getDistanceRemaining();
    }

    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    debugPrint("_distanceRemaining : $_distanceRemaining");

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });

        if (_routeBuilt) {
          await _controller?.startNavigation();
        }

        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
