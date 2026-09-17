import 'package:flutter/material.dart';

class TempBadge extends StatelessWidget {
  final String label;
  final num tempC;
  final Color color;

  const TempBadge({
    super.key,
    required this.label,
    required this.tempC,
    required this.color,
  });

  const TempBadge.max({super.key, required this.tempC})
    : label = 'Max',
      color = const Color(0xFFE5484D);

  const TempBadge.min({super.key, required this.tempC})
    : label = 'Min',
      color = const Color(0xFF2E7DD7);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label: ${tempC.toStringAsFixed(1)}°C',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
