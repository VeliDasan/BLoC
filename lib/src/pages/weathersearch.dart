import 'dart:async';
import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_bloc.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_event.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_state.dart';

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
      appBar: appBar(context: context, title: 'Hava Durumu Bilgileri'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Şehir Ara",
                hintStyle: const TextStyle(color: Colors.black),
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        context
                            .read<WeatherBloc>()
                            .add(GetWeather(_controller.text));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.red,
                      onPressed: () {
                        _controller.clear();
                        context
                            .read<WeatherBloc>()
                            .add(const GetCitySuggestions(''));
                      },
                    ),
                  ],
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (value) {
                context.read<WeatherBloc>().add(GetWeather(value));
              },
            ),
          ),
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
                          context
                              .read<WeatherBloc>()
                              .add(GetWeather(state.cities[index]));
                        },
                      );
                    },
                  ),
                );
              } else if (state is WeatherLoadingState) {
                return const Center();
              } else if (state is WeatherSuccessState) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_city, size: 24),
                              const SizedBox(width: 8),
                              Text('City: ${state.weatherDetailData.name}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.thermostat, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                  'Temperature: ${state.weatherDetailData.tempC}°C',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is WeatherErrorState) {
                return const Center(/*child: Text('veriler çekilemedi hata')*/);
              } else {
                return const Center(/*child: Text('şehir aratınız')*/);
              }
            },
          ),
        ],
      ),
    );
  }
}
