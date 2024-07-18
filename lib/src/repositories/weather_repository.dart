import 'package:dio/dio.dart';
import '../models/weather.dart';

class WeatherRepository {
  Future<Weather?> getWeather() async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = "application/json; charset=UTF-8";
    var response = await dio.get(
        'https://api.weatherapi.com/v1/current.json?key=baf35198716c4b8d9a7123131241807&q=Istanbul');
    print(response);
    if (response.statusCode == 200) {
      var data = response.data['current'];
      Weather weather = Weather.fromJson(data);
      return weather;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
