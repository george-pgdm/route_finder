import 'package:hive/hive.dart';
import 'package:locaview/features/home/presentation/controllers/location_model.dart';

class HiveService {
  static const String _boxName = 'locationHistory';

  static Box<LocationModel>? _box;

  static Future<void> openBox() async {
    _box ??= await Hive.openBox<LocationModel>(_boxName);
  }

  static Future<void> closeBox() async {
    await _box?.close();
  }

  static Future<void> addLocationHistory(LocationModel history) async {
    await _box?.put(history.id, history);
  }

  static Future<List<LocationModel>> getAllLocationHistory() async {
    return _box?.values.toList() ?? [];
  }

  static Future<void> removeLocationHistory(String id) async {
    await _box?.delete(id);
  }
}
