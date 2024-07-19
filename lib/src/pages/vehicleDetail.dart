import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/detailBLoc/detail_bloc.dart';
import '../blocs/detailBLoc/detail_event.dart';
import '../blocs/detailBLoc/detail_state.dart';
import '../elements/appBar.dart';
import '../elements/locationButton.dart';
import '../elements/pageLoading.dart';

class VehicleDetailScreen extends StatefulWidget {
  final int deviceId;

  const VehicleDetailScreen({required this.deviceId});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  GoogleMapController? _mapController;
  bool _mapVisible = false;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _moveToVehicleLocation(double latitude, double longitude) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude, longitude),
        ),
      );
    }
  }

  void _toggleMapVisibility() {
    setState(() {
      _mapVisible = !_mapVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Detay Sayfa", context: context),
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
                    Text(
                      'Device ID: ${state.vehicleDetailData.deviceId}',
                    ),
                    Text(
                      'Fuel Tank Level: ${state.vehicleDetailData.fuelTankLevel}%',
                    ),
                    Text('Longitude: ${state.vehicleDetailData.longitude}'),
                    Text('Latitude: ${state.vehicleDetailData.latitude}'),
                    Text('KM: ${state.vehicleDetailData.km}'),
                    Text('Speed: ${state.vehicleDetailData.speed} km/h'),
                    // Add Google Map widget
                    Visibility(
                      visible: _mapVisible,
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            // Initialize the map controller
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                state.vehicleDetailData.latitude,
                                state.vehicleDetailData.longitude,
                              ),
                              zoom: 14,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId('vehicle_location'),
                                position: LatLng(
                                  state.vehicleDetailData.latitude,
                                  state.vehicleDetailData.longitude,
                                ),
                                infoWindow:
                                    InfoWindow(title: 'Vehicle Location'),
                              ),
                            },
                          ),
                        ),
                      ),
                    ),
                    locationButton(
                      onPressed: () {
                        _toggleMapVisibility();
                        _moveToVehicleLocation(
                          state.vehicleDetailData.latitude,
                          state.vehicleDetailData.longitude,
                        );
                      },
                      title: "Konuma Git",
                    ),
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
