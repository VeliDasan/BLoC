import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../repositories/vehicle_repository.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String plate;

  const VehicleDetailScreen({Key? key, required this.plate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: 'Araç Detayları'),
      body: FutureBuilder(
        future: _getVehicleDetails(plate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  _buildInfoCard(
                    title: 'Fuel Tank Level',
                    value: '${vehicle['fuelTankLevel']}',
                  ),
                  _buildInfoCard(
                    title: 'Longitude',
                    value: '${vehicle['longitude']}',
                  ),
                  _buildInfoCard(
                    title: 'Latitude',
                    value: '${vehicle['latitude']}',
                  ),
                  _buildInfoCard(
                    title: 'Speed',
                    value: '${vehicle['speed']} km/h',
                  ),
                  _buildInfoCard(
                    title: 'Device ID',
                    value: '${vehicle['deviceId']}',
                  ),
                  _buildInfoCard(
                    title: 'KM',
                    value: '${vehicle['km']} km',
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
            return Center(child: Text('No data'));
          }
        },
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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
