import 'package:bloc_yapisi/src/models/weather.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherLoadingState extends WeatherState {
  @override
  List<dynamic> get props => [];
}

class WeatherSuccessState extends WeatherState {
  const WeatherSuccessState({required this.WeatherDetailData});

  final  Weather WeatherDetailData;//K

  @override
  List<dynamic> get props => [];
}

class WeatherErrorState extends WeatherState {
  @override
  List<dynamic> get props => [];
}
