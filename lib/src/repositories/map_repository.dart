import '../models/vehicleDetail.dart';
import '../utils/global.dart';

class MapRepository{
  Future<VehicleDetail> getMapDetail({required int deviceId}) async {
    return vehicleDetailList
        .where((element) => element.deviceId == deviceId)
        .first;
  }
}