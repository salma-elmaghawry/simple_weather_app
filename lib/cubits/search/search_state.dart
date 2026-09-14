import 'package:simple_weather_app/models/weather_city_model.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<WeatherCityModel> cities;

  const SearchSuccess(this.cities);
}

class SearchFailure extends SearchState {
  final String errorMessage;

  const SearchFailure(this.errorMessage);
}
