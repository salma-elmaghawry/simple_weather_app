import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_weather_app/core/routes/routes.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';
import 'package:simple_weather_app/ui/views/intro_view.dart';
import 'package:simple_weather_app/ui/views/search_view.dart';
import 'package:simple_weather_app/ui/views/weather_view.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case Routes.intro:
        return MaterialPageRoute(builder: (_) => const IntroView());

      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchView());

      case Routes.weather:
         final city=settings.arguments as WeatherCityModel;
        return MaterialPageRoute(builder: (_) => WeatherView(city: city));

      default:
        // Returning null here lets MaterialApp's onUnknownRoute handle it,
        // instead of showing a raw "No route defined for ..." screen.
        return null;
    }
  }
}
