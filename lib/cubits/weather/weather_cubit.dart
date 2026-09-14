import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_weather_app/cubits/weather/weather_state.dart';
import 'package:simple_weather_app/services/weather_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;

  WeatherCubit(this.weatherService) : super(WeatherInitial());

  Future<void> fetchWeather(String query) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherService.fetchWeather(query: query);
      emit(WeatherSuccess(weather));
    } catch (e) {
      emit(
        const WeatherFailure(
          'Please try searching again or check your internet connection',
        ),
      );
    }
  }
}
