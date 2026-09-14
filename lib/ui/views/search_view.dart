import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Navigator.pop(context, city);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(WeatherService()),
      child: Builder(
        builder: (context) {
          final cubit = context.read<SearchCubit>();
          return Scaffold(
            appBar: AppBar(title: const Text('Search City')),
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
                            return const Center(child: Text('No cities found'));
                          }

                          return ListView.separated(
                            itemCount: state.cities.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final city = state.cities[index];
                              return ListTile(
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text(city.name),
                                subtitle: Text(
                                  '${city.region}, ${city.country}',
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
          );
        },
      ),
    );
  }
}
