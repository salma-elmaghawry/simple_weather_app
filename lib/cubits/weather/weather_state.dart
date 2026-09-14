import 'package:simple_weather_app/models/weather_model.dart';

abstract class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final WeatherModel weather;

  const WeatherSuccess(this.weather);
}

class WeatherFailure extends WeatherState {
  final String errorMessage;

  const WeatherFailure(this.errorMessage);
}
