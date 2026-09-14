import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_weather_app/cubits/search/search_state.dart';
import 'package:simple_weather_app/services/weather_service.dart';

class SearchCubit extends Cubit<SearchState> {
  final WeatherService weatherService;

  SearchCubit(this.weatherService) : super(SearchInitial());

  Future<void> searchCities(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 2) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final cities = await weatherService.searchCities(trimmedQuery);
      emit(SearchSuccess(cities));
    } catch (e) {
      emit(const SearchFailure('Failed to load city suggestions'));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
