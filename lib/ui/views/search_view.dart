import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_weather_app/const/gradients.dart';
import 'package:simple_weather_app/cubits/search/search_cubit.dart';
import 'package:simple_weather_app/cubits/search/search_state.dart';
import 'package:simple_weather_app/models/weather_city_model.dart';
import 'package:simple_weather_app/services/weather_service.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

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
    debounce = Timer(const Duration(seconds: 1), () {
      cubit.searchCities(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(WeatherService()),
      child: Builder(
        builder: (context) {
          final cubit = context.read<SearchCubit>();

          void onCitySelected(WeatherCityModel city) async {
            searchController.text = '${city.name}, ${city.country}';

            context.read<SearchCubit>().clearSearch();
            Navigator.pop(context);
            log('City selected: ${city.name}, ${city.country}');
            debugPrint('Selected city: ${city.name}');
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: backgroundGradient),

            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text('Search City'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search City',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => onSearchChanged(value, cubit),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          if (state is SearchInitial) {
                            return const SizedBox();
                          }

                          if (state is SearchLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is SearchFailure) {
                            return Center(child: Text(state.errorMessage));
                          }

                          if (state is SearchSuccess) {
                            if (state.cities.isEmpty) {
                              return const Center(
                                child: Text('No cities found'),
                              );
                            }

                            return ListView.separated(
                              itemCount: state.cities.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final city = state.cities[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                  ),
                                  title: Text(city.name),
                                  subtitle: Text(
                                    '${city.region}, ${city.country}',
                                  ),
                                  onTap: () => onCitySelected(city),
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
          );
        },
      ),
    );
  }
}
