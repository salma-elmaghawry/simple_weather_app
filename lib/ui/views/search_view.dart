import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather_app/core/const.dart';
import 'package:simple_weather_app/core/routes/routes.dart';
import 'package:simple_weather_app/cubits/search/search_cubit.dart';
import 'package:simple_weather_app/cubits/search/search_state.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';
import 'package:simple_weather_app/services/weather_service.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  static const String routeName = '/search';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  Timer? debounce;

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged(String value, SearchCubit cubit) {
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 500), () {
      cubit.searchCities(value);
    });
  }

  void onCitySelected(WeatherCityModel city, SearchCubit cubit) {
    searchController.text = '${city.name}, ${city.country}';
    cubit.clearSearch();
    Navigator.pushNamed(context, Routes.weather, arguments: city);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(WeatherService()),
      child: Builder(
        builder: (context) {
          final cubit = context.read<SearchCubit>();
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                'Search City',
                style: GoogleFonts.kadwa(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: backgroundGradient,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: searchController,
                          autofocus: true,
                          style: GoogleFonts.kadwa(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search City',
                            hintStyle: GoogleFonts.kadwa(
                              color: Colors.white70,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) => onSearchChanged(value, cubit),
                        ),
                        const SizedBox(height: 12),
                        Flexible(
                          child: BlocBuilder<SearchCubit, SearchState>(
                            builder: (context, state) {
                              if (state is SearchInitial) {
                                return const SizedBox();
                              }

                              if (state is SearchLoading) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }

                              if (state is SearchFailure) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Center(
                                    child: Text(
                                      state.errorMessage,
                                      style: GoogleFonts.kadwa(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (state is SearchSuccess) {
                                if (state.cities.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'No cities found',
                                        style: GoogleFonts.kadwa(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: state.cities.length,
                                  separatorBuilder: (_, _) => const Divider(
                                    color: Colors.white24,
                                    height: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    final city = state.cities[index];
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white70,
                                      ),
                                      title: Text(
                                        city.name,
                                        style: GoogleFonts.kadwa(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${city.region}, ${city.country}',
                                        style: GoogleFonts.kadwa(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      onTap: () => onCitySelected(city, cubit),
                                    );
                                  },
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
