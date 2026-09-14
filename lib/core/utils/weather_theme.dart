import 'package:flutter/material.dart';

/// Picks a background gradient for the Weather view based on the current
/// condition and time of day. We don't have a photo API key wired in yet
/// (the session mentions a "Pixel/Pexels API" for city backgrounds), so we
/// use condition-based gradients as a clean placeholder instead of a real
/// city photo.
List<Color> weatherGradientColors({
  required String conditionText,
  required bool isDay,
}) {
  final condition = conditionText.toLowerCase();

  if (!isDay) {
    return const [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)];
  }

  if (condition.contains('rain') ||
      condition.contains('drizzle') ||
      condition.contains('thunder')) {
    return const [Color(0xFF4B6584), Color(0xFF778CA3)];
  }

  if (condition.contains('snow') || condition.contains('sleet')) {
    return const [Color(0xFFB8C6DB), Color(0xFFF5F7FA)];
  }

  if (condition.contains('cloud') || condition.contains('overcast')) {
    return const [Color(0xFF757F9A), Color(0xFFD7DDE8)];
  }

  if (condition.contains('mist') ||
      condition.contains('fog') ||
      condition.contains('haze')) {
    return const [Color(0xFF757F9A), Color(0xFFBFC9D4)];
  }

  // Clear / sunny default.
  return const [Color(0xFF4DA0F5), Color(0xFF9DE0FF)];
}
