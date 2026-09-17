import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_app/models/weather_model.dart';
import 'package:simple_weather_app/ui/widgets/forecast_tile.dart';

class ForecastCard extends StatelessWidget {
  final List<WeatherModel> days;

  const ForecastCard({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${days.length}-day forecast',
            textAlign: TextAlign.center,
            style: GoogleFonts.kadwa(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Divider(color: Colors.white24, height: 28),
          for (final day in days) ...[
            ForecastTile(day: day),
            if (day != days.last) const Divider(color: Colors.white24, height: 1),
          ],
        ],
      ),
    );
  }
}
