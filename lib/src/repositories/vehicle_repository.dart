import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vehicle.dart';
import '../models/vehicleDetail.dart';
import '../utils/global.dart';

class VehicleRepository {
  final CollectionReference collectionVehicles =
      FirebaseFirestore.instance.collection("vehicles");

  Future<void> addVehicleToFirestore(
      {required double fuelTankLevel,
        required double longitude,
        required  double latitude,
        required double speed,
        required  int deviceId,
        required  double km,
        required  bool isActive,
        required  int sensors,
      required String plate
      }) async {
    if (plate == null) return;

    await collectionVehicles.doc(plate).set({
      'fuelTankLevel': fuelTankLevel,
      'longitude': longitude,
      'latitude': latitude,
      'speed': speed,
      'deviceId': deviceId,
      'km': km,
      'isActive': isActive,
      'sensors': sensors,
      'plate': plate,

    });
  }

  Future<List<Vehicle>> getVehicles({required int limit}) async {
    return list.sublist(0, limit);
  }

  Future<List<Vehicle>> deleteVehicle({required int id}) async {
    list.removeWhere((vehicle) => vehicle.id == id);
    return list;
  }

  Future<VehicleDetail> getVehicleDetail({required int deviceId}) async {
    return vehicleDetailList
        .where((element) => element.deviceId == deviceId)
        .first;
  }
}
