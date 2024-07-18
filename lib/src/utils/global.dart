import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../models/vehicleDetail.dart';

Color appBarBackgroundColor = Colors.white;
Color loadingColor = Colors.blue;
List<Vehicle> list = [
  Vehicle(plate: '39 ST 437', id: 0),
  Vehicle(plate: '39 ST 437', id: 1),
  Vehicle(plate: '39 ST 437', id: 2),
  Vehicle(plate: '39 ST 437', id: 3),
  Vehicle(plate: '39 ST 437', id: 4),
  Vehicle(plate: '39 ST 437', id: 5),
];

List<VehicleDetail> vehicleDetailList = [
  VehicleDetail(
      fuelTankLevel: 10,
      longitude: 41,
      latitude: 29,
      deviceId: 0,
      km: 132.857,
      speed: 90),
  VehicleDetail(
      fuelTankLevel: 10,
      longitude: 41,
      latitude: 29,
      deviceId: 1,
      km: 132.857,
      speed: 90),
  VehicleDetail(
      fuelTankLevel: 10,
      longitude: 41,
      latitude: 29,
      deviceId: 2,
      km: 132.857,
      speed: 90),
  VehicleDetail(
      fuelTankLevel: 10,
      longitude: 41,
      latitude: 29,
      deviceId: 3,
      km: 132.857,
      speed: 90),
  VehicleDetail(
      fuelTankLevel: 10,
      longitude: 41,
      latitude: 29,
      deviceId: 4,
      km: 132.857,
      speed: 90),
  VehicleDetail(
      fuelTankLevel: 10,
      longitude: 41,
      latitude: 29,
      deviceId: 5,
      km: 132.857,
      speed: 90),
];
