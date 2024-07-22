import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_event.dart';
import 'package:bloc_yapisi/src/blocs/weatherBLoC/weather_state.dart';
import 'package:bloc_yapisi/src/models/weather.dart';
import 'package:bloc_yapisi/src/repositories/weather_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository=WeatherRepository();

  WeatherBloc() : super(WeatherLoadingState()) {
    on<GetWeather>((event, emit) async {
      emit(WeatherLoadingState());
      try {
        final Weather? weather = await weatherRepository.getWeather();
        if (weather != null) {
          print(weather);
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
