import 'package:bloc_yapisi/src/blocs/detailBLoc/detail_state.dart';
import 'package:bloc_yapisi/src/blocs/mapBLoC/map_bloc.dart';
import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:bloc_yapisi/src/elements/locationButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../repositories/vehicle_repository.dart';

class VehicleDetailScreen extends StatefulWidget {
  final String plate;

  const VehicleDetailScreen({Key? key, required this.plate}) : super(key: key);

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  GoogleMapController? _mapController;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(),
      child: Scaffold(
        appBar: appBar(context: context, title: 'Araç Detayları'),
        body: FutureBuilder(
          future: _getVehicleDetails(widget.plate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final vehicle = snapshot.data as Map<String, dynamic>;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(
                      title: 'Plate',
                      value: vehicle['plate'],
                    ),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          BlocBuilder<MapBloc, MapState>(
                            builder: (context, mapState) {
                              if (mapState is MapVisibleState) {
                                return SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: GoogleMap(
                                        onMapCreated: _onMapCreated,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            vehicle['latitude'],
                                            vehicle['longitude'],
                                          ),
                                          zoom: 14,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId('vehicle_location'),
                                            position: LatLng(
                                              vehicle['latitude'],
                                              vehicle['longitude'],
                                            ),
                                            infoWindow: const InfoWindow(title: 'Vehicle Location'),
                                          ),
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          BlocBuilder<MapBloc, MapState>(
                            builder: (context, mapState) {
                              return locationButton(
                                onPressed: () {
                                  if (mapState is MapVisibleState) {
                                    context.read<MapBloc>().add(ToggleMapVisibility(
                                      latitude: mapState.latitude,
                                      longitude: mapState.longitude,
                                    ));
                                  } else if (mapState is MapHiddenState) {
                                    context.read<MapBloc>().add(ToggleMapVisibility(
                                      latitude: vehicle['latitude'],
                                      longitude: vehicle['longitude'],
                                    ));
                                    _moveToVehicleLocation(
                                      vehicle['latitude'],
                                      vehicle['longitude'],
                                    );
                                  }
                                },
                                title: mapState is MapVisibleState ? "Konumu Gizle" : "Konuma Git",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: KdGaugeView(
                          minSpeed: 0,
                          maxSpeed: 250, // Updated with new variable
                          speed: vehicle['speed'].toDouble(),
                          animate: true,
                          duration: const Duration(seconds: 1),
                          alertSpeedArray: const [40, 80, 90],
                          alertColorArray: const [
                            Colors.orange,
                            Colors.indigo,
                            Colors.red
                          ],
                          child: Padding(
                            padding: const EdgeInsets.only(top: 150.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.speed),
                                  Text(
                                    '${vehicle['km'].toDouble()}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.local_gas_station, color: Colors.red),
                        Icon(Icons.local_gas_station, color: Colors.green),
                      ],
                    ),
                    SfLinearGauge(
                      ranges: const [
                        LinearGaugeRange(
                          startValue: 0,
                          endValue: 100,
                          color: Colors.grey,
                        ),
                      ],
                      markerPointers: [
                        LinearShapePointer(
                          value: vehicle['fuelTankLevel'].toDouble(),
                        ),
                      ],
                      barPointers: [
                        LinearBarPointer(
                          value: vehicle['fuelTankLevel'].toDouble(),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    _buildInfoCard(
                      title: 'Device ID',
                      value: '${vehicle['deviceId']}',
                    ),
                    _buildInfoCard(
                      title: 'Active',
                      value: vehicle['isActive'] ? 'Yes' : 'No',
                    ),
                    _buildInfoCard(
                      title: 'Sensors',
                      value: '${vehicle['sensors']}',
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Error loading data.'));
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getVehicleDetails(String plate) async {
    final doc = await FirebaseFirestore.instance.collection('vehicles').doc(plate).get();
    return doc.data() ?? {};
  }

  Widget _buildInfoCard({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
