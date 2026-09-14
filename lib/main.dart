import 'package:flutter/material.dart';
import 'package:simple_weather_app/core/routes/app_router.dart';
import 'package:simple_weather_app/core/routes/routes.dart';
import 'package:simple_weather_app/ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter().generateRoute,
      initialRoute: Routes.home,

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Route Not Found')),
            body: const Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }
}
