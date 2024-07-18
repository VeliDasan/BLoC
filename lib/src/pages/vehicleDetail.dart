import 'package:bloc_yapisi/src/blocs/detailBLoc/detail_bloc.dart';
import 'package:bloc_yapisi/src/blocs/detailBLoc/detail_state.dart';
import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/detailBLoc/detail_event.dart';

class VehicleDetailScreen extends StatefulWidget {
  final int deviceId;

  VehicleDetailScreen({super.key, required this.deviceId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Detay Sayfa"),
      body: BlocProvider(
        create: (context) => DetailBloc()..add(GetVehicleDetail(deviceId: widget.deviceId)),
        child: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoadingState) {
              return  const Center(child: CircularProgressIndicator());
            } else if (state is DetailSuccessState) {
              final vehicleDetail = state.vehicleDetailData;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device ID: ${vehicleDetail.deviceId}'),
                    Text('Fuel Tank Level: ${vehicleDetail.fuelTankLevel}%'),
                    Text('Longitude: ${vehicleDetail.longitude}'),
                    Text('Latitude: ${vehicleDetail.latitude}'),
                    Text('KM: ${vehicleDetail.km}'),
                    Text('Speed: ${vehicleDetail.speed} km/h'),
                  ],
                ),
              );
            } else if (state is DetailErrorState) {
              return const Center(child: Text('Detay Yüklenirken Hata Oluştu'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
