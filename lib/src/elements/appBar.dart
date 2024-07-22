import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_bloc.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_event.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_state.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:bloc_yapisi/src/pages/weathersearch.dart';
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
          onPressed: (
              ) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Weathersearch()
                       ));
            /*showDialog(
              context: context,
              builder: (context) {
                return BlocProvider<WeatherBloc>(
                  create: (context) => WeatherBloc()..add(const GetWeather()),
                  child: BlocBuilder<WeatherBloc, WeatherState>(
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
                            content: Text('veriler gelemedi'));
                      } else {
                        return const AlertDialog(
                            content: Text('bilinmeyen durum'));
                      }
                    },
                  ),
                );
              },
            );*/
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
