import 'package:bloc_yapisi/src/models/vehicleDetail.dart';
import 'package:equatable/equatable.dart';

abstract class DetailState extends Equatable {
  const DetailState();
}

class DetailLoadingState extends DetailState {
  @override
  List<dynamic> get props => [];
}

class DetailSuccessState extends DetailState {
  const DetailSuccessState({required this.vehicleDetailData});

  final VehicleDetail vehicleDetailData;

  @override
  List<dynamic> get props => [];
}

class DetailErrorState extends DetailState {
  @override
  List<dynamic> get props => [];
}
