import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';

class WeatherService {
  late Dio dio;
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static String apiKey = "b2a3f13c46dc45f5adc84756242805";

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
}
