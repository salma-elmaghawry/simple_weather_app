import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_weather_app/core/utils/handle_dio_error.dart';
import 'package:simple_weather_app/cubits/weather/weather_state.dart';
import 'package:simple_weather_app/services/weather_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;

  WeatherCubit(this.weatherService) : super(WeatherInitial());

  Future<void> fetchWeather(String cityName) async {
    emit(WeatherLoading());
    try {
      final weathers = await weatherService.getWeatherByCity(cityName);
      emit(WeatherSuccess(weathers));
    } on DioException catch (e) {
      emit(WeatherFailure(handleDioError(e)));
    } catch (e) {
      emit(
        const WeatherFailure(
          'Please try searching again or check your internet connection',
        ),
      );
    }
  }
}
