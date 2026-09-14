class WeatherCityModel {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;

  WeatherCityModel({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory WeatherCityModel.fromJson(Map<String, dynamic> json) {
    return WeatherCityModel(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  /// Query string used to request the forecast for this exact location.
  String get query => '$lat,$lon';
}
