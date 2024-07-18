import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../repositories/weather_repository.dart';
import '../utils/global.dart';

PreferredSizeWidget appBar({required BuildContext context, required String title}) => AppBar(
  centerTitle: true,
  backgroundColor: appBarBackgroundColor,
  actions: [
    IconButton(
      onPressed: () async {
        WeatherRepository weatherRepository = WeatherRepository();
        Weather? weather;
        String message;
        try {
          weather = await weatherRepository.getWeather();
          message = weather != null
              ? 'Temperature: ${weather.temp_c}°C\nDaytime: ${weather.is_day == 1 ? 'Yes' : 'No'}'
              : 'Failed to fetch weather data';
        } catch (e) {
          message = 'Error: ${e.toString()}';
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(content: Text(message)),
        );
      },
      icon: const Icon(Icons.wind_power_rounded, color: Colors.blue),
    )
  ],
  elevation: 0,
  title: Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
);
