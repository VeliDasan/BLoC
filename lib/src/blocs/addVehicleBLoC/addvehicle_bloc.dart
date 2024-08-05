import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_event.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_state.dart';
import 'package:bloc_yapisi/src/repositories/vehicle_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddvehicleBloc extends Bloc<AddVehicleEvent, AddVehicleState> {
  final VehicleRepository vehicleRepository;
  var collectionKisiler = FirebaseFirestore.instance.collection("vehicles");

  AddvehicleBloc({required this.vehicleRepository})
      : super(UnAuthenticated(error: '')) {
    on<AddVehicleRequsted>((event, emit) async {
      emit(Loading());
      try {
        await vehicleRepository.addVehicleToFirestore(
            fuelTankLevel: event.fuelTankLevel,
            longitude: event.longitude,
            latitude: event.latitude,
            speed: event.speed,
            deviceId: event.deviceId,
            km: event.km,
            isActive: event.isActive,
            sensors: event.sensors,
            plate: event.plate);
        emit(AddVehicleSuccess());
      } catch (e) {
        emit(UnAuthenticated(error: e.toString()));
      }
    });
  }
}
