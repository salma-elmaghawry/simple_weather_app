import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_app/core/routes/routes.dart';
import 'package:simple_weather_app/core/utils/weather_theme.dart';
import 'package:simple_weather_app/cubits/weather/weather_cubit.dart';
import 'package:simple_weather_app/cubits/weather/weather_state.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';
import 'package:simple_weather_app/services/weather_service.dart';
import 'package:simple_weather_app/ui/widgets/forecast_tile.dart';
import 'package:simple_weather_app/ui/widgets/temp_badge.dart';

class WeatherView extends StatelessWidget {
  final WeatherCityModel city;

  const WeatherView({super.key, required this.city});

  static const String routeName = '/weather_view';

  Future<void> _openSearch(BuildContext context, WeatherCubit cubit) async {
    final selected = await Navigator.pushNamed(context, Routes.search);
    if (selected is WeatherCityModel) {
      cubit.fetchWeather(selected.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(WeatherService())..fetchWeather(city.query),
      child: Builder(
        builder: (context) {
          final cubit = context.read<WeatherCubit>();
          return BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              final gradientColors = state is WeatherSuccess
                  ? weatherGradientColors(
                      conditionText: state.weather.conditionText,
                      isDay: state.weather.isDay,
                    )
                  : const [Color(0xFFc8c7fc), Color(0xFFFFFFFF)];

              return Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        _buildBody(context, state),
                        Positioned(
                          top: 8,
                          right: 16,
                          child: _SearchButton(
                            onTap: () => _openSearch(context, cubit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherState state) {
    if (state is WeatherLoading || state is WeatherInitial) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (state is WeatherFailure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/no_weather.png', width: 180),
              const SizedBox(height: 16),
              Text(
                'No weather data',
                style: GoogleFonts.kadwa(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.kadwa(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    final weather = (state as WeatherSuccess).weather;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            weather.date,
            style: GoogleFonts.kadwa(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            weather.cityName,
            style: GoogleFonts.kadwa(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            weather.country,
            style: GoogleFonts.kadwa(fontSize: 15, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          CachedNetworkImage(
            imageUrl: weather.conditionIconUrl,
            width: 70,
            height: 70,
            errorWidget: (context, url, error) =>
                const SizedBox(width: 70, height: 70),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                weather.conditionText,
                style: GoogleFonts.kadwa(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                '${weather.currentTempC.toStringAsFixed(1)}°C',
                style: GoogleFonts.kadwa(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TempBadge.max(tempC: weather.maxTempC),
              const SizedBox(width: 12),
              TempBadge.min(tempC: weather.minTempC),
            ],
          ),
          const SizedBox(height: 36),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2-day forecast',
                  style: GoogleFonts.kadwa(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Colors.white24, height: 20),
                for (int i = 0; i < weather.forecast.length; i++) ...[
                  ForecastTile(day: weather.forecast[i]),
                  if (i != weather.forecast.length - 1)
                    const Divider(color: Colors.white24, height: 1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.search, color: Colors.black87),
        ),
      ),
    );
  }
}
