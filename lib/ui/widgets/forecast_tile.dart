import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_app/models/weather_model.dart';

class ForecastTile extends StatelessWidget {
  final WeatherModel day;

  const ForecastTile({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            day.date,
            style: GoogleFonts.kadwa(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              day.conditionText,
              textAlign: TextAlign.center,
              style: GoogleFonts.kadwa(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${day.maxTempC.toStringAsFixed(1)}°C',
            style: GoogleFonts.kadwa(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
