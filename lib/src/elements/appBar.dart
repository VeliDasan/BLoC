import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_bloc.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_event.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_state.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/global.dart';

PreferredSizeWidget appBar({
  required BuildContext context,
  required String title,
}) =>
    AppBar(
      centerTitle: true,
      backgroundColor: appBarBackgroundColor,
      actions: [
        IconButton(
          onPressed: () {
            final weatherBloc = BlocProvider.of<WeatherBloc>(context);
            weatherBloc.add(const GetWeather());

            showDialog(
              context: context,
              builder: (context) {
                return BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherLoadingState) {
                      pageLoading();
                      return const AlertDialog();
                    } else if (state is WeatherSuccessState) {
                      return AlertDialog(
                        content: Text(
                          'Temperature: ${state.WeatherDetailData.tempC}°C\nLocation: ${state.WeatherDetailData.name}',
                        ),
                      );
                    } else if (state is WeatherErrorState) {
                      return const AlertDialog(
                          content: Text('Failed to fetch weather data'));
                    } else {
                      return const AlertDialog(content: Text('Unknown state'));
                    }
                  },
                );
              },
            );
          },
          icon: const Icon(Icons.wind_power_rounded, color: Colors.blue),
        ),
      ],
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );