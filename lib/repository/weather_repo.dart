import 'package:simple_weather_app/models/weather_model.dart';

/// Bundles everything the Weather screen needs for one city:
/// the 3-day forecast list plus a background photo of the city.
class WeatherRepo {
  final List<WeatherModel> weatherList;
  final String cityImageUrl;

  WeatherRepo({required this.weatherList, required this.cityImageUrl});
}
