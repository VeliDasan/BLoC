import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_bloc.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_event.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_state.dart';
import 'package:bloc_yapisi/src/utils/global.dart';

class Weathersearch extends StatelessWidget {
  const Weathersearch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: WeathersearchContent(),
    );
  }
}

class WeathersearchContent extends StatefulWidget {
  @override
  _WeathersearchContentState createState() => _WeathersearchContentState();
}

class _WeathersearchContentState extends State<WeathersearchContent> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.length >= 2) {
      _debounce = Timer(const Duration(), () {
        context.read<WeatherBloc>().add(GetCitySuggestions(query));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        centerTitle: true,
        title: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            bool aramaYapiliyorMu = false;
            if (state is SearchToggleState) {
              aramaYapiliyorMu = state.aramaYapiliyorMu;
            }
            return aramaYapiliyorMu
                ? TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ara",
                hintStyle: TextStyle(color: Colors.black),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (value) {
                context.read<WeatherBloc>().add(GetWeather(value));
              },
            )
                : const Text(
              "Hava Durumu Bilgileri",
              style: TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        actions: [
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              bool aramaYapiliyorMu = false;
              if (state is SearchToggleState) {
                aramaYapiliyorMu = state.aramaYapiliyorMu;
              }
              return IconButton(
                onPressed: () {
                  context.read<WeatherBloc>().add(ToggleSearch());
                },
                icon: Icon(
                  aramaYapiliyorMu ? Icons.clear : Icons.search,
                  color: aramaYapiliyorMu ? Colors.red : Colors.blueGrey,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is CitySuggestionsState) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.cities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.cities[index]),
                        onTap: () {
                          _controller.text = state.cities[index];
                          context.read<WeatherBloc>().add(GetWeather(state.cities[index]));
                        },
                      );
                    },
                  ),
                );
              } else {
                return Center(child: Text('No city suggestions available.'));
              }
            },
          ),
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is WeatherSuccessState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('City: ${state.weatherDetailData.name}'),
                      Text('Temperature: ${state.weatherDetailData.tempC}°C'),
                    ],
                  ),
                );
              } else if (state is WeatherErrorState) {
                return Center(child: Text('Error fetching weather data'));
              } else {
                return Center(child: Text('Please search for a city'));
              }
            },
          ),
        ],
      ),
    );
  }
}
