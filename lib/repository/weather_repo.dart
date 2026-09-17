import 'package:simple_weather_app/models/weather_model.dart';

class WeatherRepo {
  final List<WeatherModel> weatherList;
  final String cityImageUrl;

  WeatherRepo({required this.weatherList, required this.cityImageUrl});
}
