import 'package:dio/dio.dart';

String handleDioError(DioException error) {
  if (error.message != null) {
    final data = error.response?.data;
    if (data != null &&
        data is Map<String, dynamic> &&
        data.containsKey('error')) {
      return data['error']['message'] ?? "Failed to load Weather data. Please try again later.";
    }
  }
  if(error.type==DioExceptionType.connectionTimeout){
    return "Connection timeout. Please check your internet connection.";
  }
  if(error.type==DioExceptionType.receiveTimeout){
    return "Receive timeout. Please check your internet connection.";
  }
  if(error.type==DioExceptionType.connectionError){
    return "Connection error. Please check your internet connection.";
  }
  return "Unexpected error occurred. Please try again later.";
}