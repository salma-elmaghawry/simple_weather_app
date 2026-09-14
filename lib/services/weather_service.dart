import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';
import 'package:simple_weather_app/models/weather_model.dart';

class WeatherService {
  late Dio dio;
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static String apiKey = dotenv.env['apiKey']!;

  WeatherService() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  /// Search for cities/locations matching the text the user typed.
  Future<List<WeatherCityModel>> searchCities(String query) async {
    try {
      final response = await dio.get(
        '/search.json',
        queryParameters: {'key': apiKey, 'q': query},
      );
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((item) => WeatherCityModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load city suggestions: ${response.statusCode}',
        );
      }
    } on DioException {
      // PrettyDioLogger already logs the request/response, so we only
      // rethrow here for the Cubits to turn into a failure state.
      rethrow;
    }
  }

  /// Fetch current weather + forecast for a given city query
  /// (usually "lat,lon" so we get the exact location the user picked).
  Future<WeatherModel> fetchWeather({
    required String query,
    int days = 3,
  }) async {
    try {
      final response = await dio.get(
        '/forecast.json',
        queryParameters: {
          'key': apiKey,
          'q': query,
          'days': days,
          'aqi': 'no',
          'alerts': 'no',
        },
      );
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } on DioException {
      rethrow;
    }
  }
}
