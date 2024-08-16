import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/vehicle_repository.dart';
import 'list_event.dart';
import 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final VehicleRepository vehicleRepository;

  ListBloc(this.vehicleRepository) : super(ListInitial()) {
    on<FetchVehicles>(_onFetchVehicles);
    on<DeleteVehicle>(_onDeleteVehicle);
    on<UpdateVehicleList>(_onUpdateVehicleList);
  }

  void _onFetchVehicles(FetchVehicles event, Emitter<ListState> emit) async {
    emit(ListLoading());
    try {
      // Fetch the user document
      final userDoc = await FirebaseFirestore.instance
          .collection('Kisiler')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final vehicleIdList = userDoc.data()!['vehicleIdList'] as List<String>;
        final vehicleDetails = await Future.wait(
          vehicleIdList.map((plate) => vehicleRepository.getVehicleDetailStream(plate).first),
        );
        emit(ListLoaded(vehicleIdList, vehicleDetails));
      } else {
        emit(ListError("User data not found"));
      }
    } catch (e) {
      emit(ListError("Failed to fetch vehicle plates: ${e.toString()}"));
    }
  }

  void _onUpdateVehicleList(UpdateVehicleList event, Emitter<ListState> emit) {
    emit(ListLoaded(event.plates, event.vehicleDetails));
  }

  Future<void> _onDeleteVehicle(DeleteVehicle event, Emitter<ListState> emit) async {
    try {
      await vehicleRepository.deleteVehicle(event.plate);

      // Fetch the user document to get the updated vehicleIdList
      final userDoc = await FirebaseFirestore.instance
          .collection('Kisiler')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final vehicleIdList = userDoc.data()!['vehicleIdList'] as List<String>;
        final vehicleDetails = await Future.wait(
          vehicleIdList.map((plate) => vehicleRepository.getVehicleDetailStream(plate).first),
        );
        emit(ListLoaded(vehicleIdList, vehicleDetails));
      } else {
        emit(ListError("User data not found"));
      }
    } catch (e) {
      emit(ListError(e.toString()));
    }
  }
}


