class WeatherModel {
  final String cityName;
  final String country;
  final String date;
  final String conditionText;
  final String conditionIconUrl;
  final num maxTempC;
  final num minTempC;
  final num avgTempC;

  WeatherModel({
    required this.cityName,
    required this.date,
    required this.conditionText,
    required this.conditionIconUrl,
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.country,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, int dayIndex) {
    return WeatherModel(
      cityName: json['location']['name'],
      date: json['forecast']['forecastday'][dayIndex]['date'],
      conditionText:
          json['forecast']['forecastday'][dayIndex]['day']['condition']['text'],
      conditionIconUrl:
          'https:${json['forecast']['forecastday'][dayIndex]['day']['condition']['icon']}',
      maxTempC: json['forecast']['forecastday'][dayIndex]['day']['maxtemp_c'],
      minTempC: json['forecast']['forecastday'][dayIndex]['day']['mintemp_c'],
      avgTempC: json['forecast']['forecastday'][dayIndex]['day']['avgtemp_c'],
      country: json['location']['country'],
    );
  }
}
