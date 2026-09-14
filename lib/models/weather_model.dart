class WeatherModel {
  final String cityName;
  final String region;
  final String country;
  final String date;
  final bool isDay;
  final double currentTempC;
  final String conditionText;
  final String conditionIconUrl;
  final double maxTempC;
  final double minTempC;
  final List<ForecastDayModel> forecast;

  WeatherModel({
    required this.cityName,
    required this.region,
    required this.country,
    required this.date,
    required this.isDay,
    required this.currentTempC,
    required this.conditionText,
    required this.conditionIconUrl,
    required this.maxTempC,
    required this.minTempC,
    required this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final current = json['current'];
    final List forecastDays = json['forecast']['forecastday'];
    final today = forecastDays.first;

    final String localtime = location['localtime'] as String;
    final String todayDate = localtime.split(' ').first;

    return WeatherModel(
      cityName: location['name'],
      region: location['region'],
      country: location['country'],
      date: todayDate,
      isDay: current['is_day'] == 1,
      currentTempC: (current['temp_c'] as num).toDouble(),
      conditionText: current['condition']['text'],
      conditionIconUrl: 'https:${current['condition']['icon']}',
      maxTempC: (today['day']['maxtemp_c'] as num).toDouble(),
      minTempC: (today['day']['mintemp_c'] as num).toDouble(),
      forecast: forecastDays
          .skip(1)
          .map((day) => ForecastDayModel.fromJson(day))
          .toList(),
    );
  }
}

class ForecastDayModel {
  final String date;
  final String conditionText;
  final String conditionIconUrl;
  final double maxTempC;
  final double minTempC;

  ForecastDayModel({
    required this.date,
    required this.conditionText,
    required this.conditionIconUrl,
    required this.maxTempC,
    required this.minTempC,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    return ForecastDayModel(
      date: json['date'],
      conditionText: json['day']['condition']['text'],
      conditionIconUrl: 'https:${json['day']['condition']['icon']}',
      maxTempC: (json['day']['maxtemp_c'] as num).toDouble(),
      minTempC: (json['day']['mintemp_c'] as num).toDouble(),
    );
  }
}
