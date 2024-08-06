import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_bloc.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_event.dart';
import 'package:bloc_yapisi/src/blocs/addVehicleBLoC/addvehicle_state.dart';
import 'package:bloc_yapisi/src/repositories/vehicle_repository.dart';

class AddVehicle extends StatelessWidget {
  final Map<String, dynamic>? vehicleData;
  final _formKey = GlobalKey<FormState>(); // Define the form key here

  AddVehicle({super.key, this.vehicleData}) {
    _fuelTankLevelController = TextEditingController(text: vehicleData?['fuelTankLevel']?.toString());
    _longitudeController = TextEditingController(text: vehicleData?['longitude']?.toString());
    _latitudeController = TextEditingController(text: vehicleData?['latitude']?.toString());
    _speedController = TextEditingController(text: vehicleData?['speed']?.toString());
    _deviceIdController = TextEditingController(text: vehicleData?['deviceId']?.toString());
    _kmController = TextEditingController(text: vehicleData?['km']?.toString());
    _sensorsController = TextEditingController(text: vehicleData?['sensors']?.toString());
    _plateController = TextEditingController(text: vehicleData?['plate']?.toString());
  }

  late final TextEditingController _fuelTankLevelController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _speedController;
  late final TextEditingController _deviceIdController;
  late final TextEditingController _kmController;
  late final TextEditingController _sensorsController;
  late final TextEditingController _plateController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddvehicleBloc(vehicleRepository: VehicleRepository()),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: appBar(context: context, title: "Araç Kayıt"),
          body: BlocConsumer<AddvehicleBloc, AddVehicleState>(
            listener: (context, state) {
              if (state is AddVehicleSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Araç başarıyla kaydedildi!')),
                );
                Navigator.pop(context);
              } else if (state is UnAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Hata: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              if (state is Loading) {
                return pageLoading();
              }
              bool isActive = state is IsActiveChanged ? state.isActive : true;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextFormField(
                        controller: _fuelTankLevelController,
                        labelText: 'Fuel Tank Level',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter fuel tank level' : null,
                      ),
                      _buildTextFormField(
                        controller: _longitudeController,
                        labelText: 'Longitude',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter longitude' : null,
                      ),
                      _buildTextFormField(
                        controller: _latitudeController,
                        labelText: 'Latitude',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter latitude' : null,
                      ),
                      _buildTextFormField(
                        controller: _speedController,
                        labelText: 'Speed',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter speed' : null,
                      ),
                      _buildTextFormField(
                        controller: _deviceIdController,
                        labelText: 'Device ID',
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter device ID' : null,
                      ),
                      _buildTextFormField(
                        controller: _kmController,
                        labelText: 'KM',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter KM' : null,
                      ),
                      BlocBuilder<AddvehicleBloc, AddVehicleState>(
                        builder: (context, state) {
                          bool isActive = state is IsActiveChanged ? state.isActive : true;
                          return SwitchListTile(
                            title: Text('Is Active'),
                            value: isActive,
                            onChanged: (bool value) {
                              context.read<AddvehicleBloc>().add(ToggleIsActive(isActive: value));
                            },
                          );
                        },
                      ),
                      _buildTextFormField(
                        controller: _sensorsController,
                        labelText: 'Sensors',
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter sensors' : null,
                      ),
                      _buildTextFormField(
                        controller: _plateController,
                        labelText: 'Plate',
                        keyboardType: TextInputType.text,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter plate number' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final fuelTankLevel = double.parse(_fuelTankLevelController.text);
                            final longitude = double.parse(_longitudeController.text);
                            final latitude = double.parse(_latitudeController.text);
                            final speed = double.parse(_speedController.text);
                            final deviceId = int.parse(_deviceIdController.text);
                            final km = double.parse(_kmController.text);
                            final isActive = context.read<AddvehicleBloc>().isActive;
                            final sensors = int.parse(_sensorsController.text);
                            final plate = _plateController.text;

                            context.read<AddvehicleBloc>().add(
                              AddVehicleRequsted(
                                fuelTankLevel: fuelTankLevel,
                                longitude: longitude,
                                latitude: latitude,
                                speed: speed,
                                deviceId: deviceId,
                                km: km,
                                isActive: isActive,
                                sensors: sensors,
                                plate: plate,
                              ),
                            );
                          }
                        },
                        child: Text('Kaydet'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
