import 'package:hive/hive.dart';
part 'location_model.g.dart';

@HiveType(typeId: 0)
class LocationModel {
  @HiveField(0)
  final String startName;
  @HiveField(1)
  final String endName;

  @HiveField(2)
  final String id;

  @HiveField(3)
  final double startLatitude;

  @HiveField(4)
  final double startLongitude;
  @HiveField(5)
  final double endLatitude;

  @HiveField(6)
  final double endLongitude;

  LocationModel(
      {required this.startName,
      required this.endName,
      required this.id,
      required this.startLatitude,
      required this.startLongitude,
      required this.endLatitude,
      required this.endLongitude});
}
