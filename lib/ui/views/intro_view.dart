import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_app/core/routes/routes.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  static const String routeName = '/intro_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFc8c7fc), Color(0xFFc8c7fc), Color(0xFFFFFFFF)],
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 3),
                Image.asset('assets/images/icon_weather.png', width: 200),
                const SizedBox(height: 16),
                Text(
                  'Weather',
                  style: GoogleFonts.kadwa(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D2A4A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@Easy Learn Academy',
                  style: GoogleFonts.kadwa(
                    fontSize: 13,
                    color: const Color(0xFF6B6890),
                  ),
                ),
                const Spacer(flex: 4),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6FC3E0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => _onLetsStart(context),
                    child: Text(
                      "let's start",
                      style: GoogleFonts.kadwa(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLetsStart(BuildContext context) async {
    final city = await Navigator.pushNamed(context, Routes.search);
    if (city is WeatherCityModel && context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.weather, arguments: city);
    }
  }
}
