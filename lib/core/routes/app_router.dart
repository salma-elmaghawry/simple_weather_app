import 'package:flutter/material.dart';
import 'package:simple_weather_app/core/routes/routes.dart';
import 'package:simple_weather_app/ui/views/intro_view.dart';
import 'package:simple_weather_app/ui/views/search_view.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.intro:
        return MaterialPageRoute(builder: (_) => const IntroView());

      case Routes.search:
        return MaterialPageRoute(builder: (_) => const SearchView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
