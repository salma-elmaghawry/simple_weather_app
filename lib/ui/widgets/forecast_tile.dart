import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_weather_app/models/weather_model.dart';

class ForecastTile extends StatelessWidget {
  final ForecastDayModel day;

  const ForecastTile({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            day.date,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(width: 12),
          CachedNetworkImage(
            imageUrl: day.conditionIconUrl,
            width: 28,
            height: 28,
            errorWidget: (context, url, error) =>
                const SizedBox(width: 28, height: 28),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              day.conditionText,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Text(
            '${day.maxTempC.toStringAsFixed(1)}°C',
            style: const TextStyle(
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
