

class Weather {


  final double temp_c;
  final int is_day;

  Weather(
      { required this.temp_c, required this.is_day});

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(

      temp_c: json["temp_c"],
      is_day: json["is_day"],
    );
  }

}
