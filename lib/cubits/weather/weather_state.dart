import 'package:simple_weather_app/repository/weather_repo.dart';

abstract class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final WeatherRepo weathers;

  const WeatherSuccess(this.weathers);
}

class WeatherFailure extends WeatherState {
  final String errorMessage;

  const WeatherFailure(this.errorMessage);
}
