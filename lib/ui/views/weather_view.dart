import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_app/core/const.dart';
import 'package:simple_weather_app/core/routes/routes.dart';
import 'package:simple_weather_app/cubits/weather/weather_cubit.dart';
import 'package:simple_weather_app/cubits/weather/weather_state.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';
import 'package:simple_weather_app/models/weather_model.dart';
import 'package:simple_weather_app/services/weather_service.dart';
import 'package:simple_weather_app/ui/widgets/forecast_tile.dart';
import 'package:simple_weather_app/ui/widgets/temp_badge.dart';

class WeatherView extends StatelessWidget {
  final WeatherCityModel city;

  const WeatherView({super.key, required this.city});

  void _openSearch(BuildContext context) {
    Navigator.pushNamed(context, Routes.search);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(WeatherService())..fetchWeather(city.query),
      child: Scaffold(
        body: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            final cityImageUrl = state is WeatherSuccess
                ? state.weathers.cityImageUrl
                : '';

            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: backgroundGradient,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (cityImageUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: cityImageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const SizedBox.shrink(),
                    ),
                  // Darken the photo so the white forecast text stays
                  // readable on top of it.
                  if (cityImageUrl.isNotEmpty)
                    Container(color: Colors.black.withValues(alpha: 0.25)),
                  SafeArea(
                    child: Stack(
                      children: [
                        _buildBody(context, state),
                        Positioned(
                          top: 8,
                          right: 16,
                          child: _SearchButton(
                            onTap: () => _openSearch(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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

    final weathers = (state as WeatherSuccess).weathers.weatherList;
    final today = weathers.first;
    final forecastDays = weathers.skip(1).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CurrentWeatherCard(weather: today),
          const SizedBox(height: 20),
          _ForecastCard(days: forecastDays),
        ],
      ),
    );
  }
}

class _CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const _CurrentWeatherCard({required this.weather});

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

class _ForecastCard extends StatelessWidget {
  final List<WeatherModel> days;

  const _ForecastCard({required this.days});

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

class _SearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black45,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.search, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
