import '../models/vehicle.dart';
import '../utils/global.dart';

class VehicleRepository {
  Future<List<Vehicle>> getVehicles({required int limit}) async {
    return list.sublist(0, limit);
  }

  Future<List<Vehicle>> deleteVehicle({required int id}) async {
    list.removeWhere((vehicle) => vehicle.id == id);
    return list;
  }
}

