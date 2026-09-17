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
import 'package:simple_weather_app/ui/widgets/current_weather_card.dart';
import 'package:simple_weather_app/ui/widgets/forcast_card.dart';
import 'package:simple_weather_app/ui/widgets/forecast_tile.dart';
import 'package:simple_weather_app/ui/widgets/search_button.dart';
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
                // Use StackFit.expand to make the background image cover the entire screen
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
                  if (cityImageUrl.isNotEmpty)
                    Container(color: Colors.black.withValues(alpha: 0.25)),
                  SafeArea(
                    child: Stack(
                      children: [
                        _buildBody(context, state),
                        Positioned(
                          top: 8,
                          right: 16,
                          child: SearchButton(
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
          CurrentWeatherCard(weather: today),
          const SizedBox(height: 20),
          ForecastCard(days: forecastDays),
        ],
      ),
    );
  }
}

