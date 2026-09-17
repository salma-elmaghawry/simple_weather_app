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
  
      rethrow;
    }
  }

 //get city photo from Pexels to use as the Weather screen background
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
      return photos[0]['src']['original'];
    } catch (_) {
      // A missing/invalid Pexels key or network hiccup shouldn't break
      // the weather fetch — just fall back to no background photo.
      return '';
    }
  }

 //get weather by city name
  Future<WeatherRepo> getWeatherByCity(String cityName) async {
    try {
      final response = await dio.get(
        '/forecast.json',
        queryParameters: {'key': apiKey, 'q': cityName, 'days': 3},
      );
      if (response.statusCode == 200) {
        final data=response.data;
        List<WeatherModel> weatherList = [
          WeatherModel.fromJson(data, 0),
          WeatherModel.fromJson(data, 1),
          WeatherModel.fromJson(data, 2),

        ];
        final cityImage = await getCityImage(cityName);
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
