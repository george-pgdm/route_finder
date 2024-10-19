// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 0;

  @override
  LocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModel(
      startName: fields[0] as String,
      endName: fields[1] as String,
      id: fields[2] as String,
      startLatitude: fields[3] as double,
      startLongitude: fields[4] as double,
      endLatitude: fields[5] as double,
      endLongitude: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startName)
      ..writeByte(1)
      ..write(obj.endName)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.startLatitude)
      ..writeByte(4)
      ..write(obj.startLongitude)
      ..writeByte(5)
      ..write(obj.endLatitude)
      ..writeByte(6)
      ..write(obj.endLongitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
