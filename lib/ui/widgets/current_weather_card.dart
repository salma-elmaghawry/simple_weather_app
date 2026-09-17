import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_app/models/weather_model.dart';
import 'package:simple_weather_app/ui/widgets/temp_badge.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            weather.date,
            style: GoogleFonts.kadwa(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            weather.cityName,
            style: GoogleFonts.kadwa(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            weather.country,
            style: GoogleFonts.kadwa(fontSize: 15, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          CachedNetworkImage(
            imageUrl: weather.conditionIconUrl,
            width: 64,
            height: 64,
            errorWidget: (context, url, error) =>
                const SizedBox(width: 64, height: 64),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                weather.conditionText,
                style: GoogleFonts.kadwa(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Text(
                '${weather.avgTempC.toStringAsFixed(1)}°C',
                style: GoogleFonts.kadwa(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TempBadge.max(tempC: weather.maxTempC),
              const SizedBox(width: 12),
              TempBadge.min(tempC: weather.minTempC),
            ],
          ),
        ],
      ),
    );
  }
}