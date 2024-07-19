import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_event.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_state.dart';
import 'package:bloc_yapisi/src/models/weather.dart';
import 'package:bloc_yapisi/src/repositories/weather_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherLoadingState()) {
    on<GetWeather>((event, emit) async {
      emit(WeatherLoadingState());
      await Future.delayed(const Duration(milliseconds: 1555));
      try {
        final Weather? weather = await weatherRepository.getWeather();
        if (weather != null) {
          emit(WeatherSuccessState(WeatherDetailData: weather));
        } else {
          emit(WeatherErrorState());
        }
      } catch (e) {
        emit(WeatherErrorState());
      }
    });
  }
}
