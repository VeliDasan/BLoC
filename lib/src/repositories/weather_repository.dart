import 'package:dio/dio.dart';
import '../models/weather.dart';
import '../utils/global.dart';

class WeatherRepository {
  Future<Weather?> getWeather() async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = "application/json; charset=UTF-8";
    print("aaa");
    var response = await dio.get(
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=Istanbul');
    print(response);
    if (response.statusCode == 200) {
      Weather weather = Weather.fromJson(response.data);
      return weather;
    } else {
      throw Exception('veriler gelemedi');
    }
  }
}
