import '../models/vehicle.dart';
import '../models/vehicleDetail.dart';
import '../utils/global.dart';

class VehicleRepository {
  Future<List<Vehicle>> getVehicles({required int limit}) async {
    return list.sublist(0, limit);
  }

  Future<List<Vehicle>> deleteVehicle({required int id}) async {
    list.removeWhere((vehicle) => vehicle.id == id);
    return list;
  }

  Future<VehicleDetail> getVehicleDetail({required int deviceId}) async {
    
    
    
    
    
    return VehicleDetail(
        fuelTankLevel: 10,
        longitude: 10,
        latitude: 10,
        deviceId: 10,
        speed: 10,
        km: 10);
  }
}
