import 'package:bloc_yapisi/src/blocs/detailBLoc/detail_bloc.dart';
import 'package:bloc_yapisi/src/blocs/detailBLoc/detail_state.dart';
import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_yapisi/src/blocs/detailBLoc/detail_event.dart';

class AScreen extends StatelessWidget {
  final String name;

  const AScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'DENEME',context: context),
      body: Center(
        child: Text(name),
      ),
    );
  }
}

class VehicleDetailScreen extends StatefulWidget {
  final int deviceId;

  const VehicleDetailScreen({required this.deviceId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Detay Sayfa",context: context),
      body: BlocProvider(
        create: (context) =>
            DetailBloc()..add(GetVehicleDetail(deviceId: widget.deviceId)),
        child: BlocConsumer<DetailBloc, DetailState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is DetailLoadingState) {
              return pageLoading();
            } else if (state is DetailSuccessState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AScreen(
                                      name: state
                                          .vehicleDetailData.deviceId
                                          .toString())));
                        },
                        child: Text(
                            'Device ID: ${state.vehicleDetailData.deviceId}')),
                    Text(
                        'Fuel Tank Level: ${state.vehicleDetailData.fuelTankLevel}%'),
                    Text('Longitude: ${state.vehicleDetailData.longitude}'),
                    Text('Latitude: ${state.vehicleDetailData.latitude}'),
                    Text('KM: ${state.vehicleDetailData.km}'),
                    Text('Speed: ${state.vehicleDetailData.speed} km/h'),
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
