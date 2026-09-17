import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';
import 'package:simple_weather_app/models/weather_model.dart';
import 'package:simple_weather_app/repository/weather_repo.dart';

class WeatherService {
  late Dio dio;
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static const String pexelsBaseUrl = 'https://api.pexels.com/v1';
  static String apiKey = dotenv.env['apiKey']!;
  static String pexelsApiKey = dotenv.env['pexelsApiKey'] ?? '';

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
      rethrow;
    }
  }

  Future<String> getCityImage(String city) async {
    if (pexelsApiKey.isEmpty) return '';
    try {
      final response = await Dio().get(
        '$pexelsBaseUrl/search',
        queryParameters: {'query': city, 'per_page': 1},
        options: Options(headers: {'Authorization': pexelsApiKey}),
      );
      final photos = response.data['photos'] as List;
      if (photos.isEmpty) return '';
      return photos[0]['src']['portrait'];
    } catch (_) {
      return '';
    }
  }

  Future<WeatherRepo> getWeatherByCity(String cityName) async {
    try {
      final results = await Future.wait([
        dio.get(
          '/forecast.json',
          queryParameters: {'key': apiKey, 'q': cityName, 'days': 3},
        ),
        getCityImage(cityName),
      ]);
      final response = results[0] as Response;
      final cityImage = results[1] as String;

      if (response.statusCode == 200) {
        final data = response.data;
        List<WeatherModel> weatherList = [
          WeatherModel.fromJson(data, 0),
          WeatherModel.fromJson(data, 1),
          WeatherModel.fromJson(data, 2),
        ];
        return WeatherRepo(weatherList: weatherList, cityImageUrl: cityImage);
      } else {
        throw Exception(
          'Failed to load weather data: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    }
  }
}
