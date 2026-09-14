import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_app/core/routes/app_router.dart';
import 'package:simple_weather_app/core/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6FC3E0),
        textTheme: GoogleFonts.kadwaTextTheme(),
      ),
      onGenerateRoute: AppRouter().generateRoute,
      initialRoute: Routes.intro,

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
