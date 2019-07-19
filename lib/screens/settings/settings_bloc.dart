import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavern/screens/bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() {
    loadFromPrefs(initialState).then((state) {
      dispatch(ChangeStateEvent(state: initialState));
    });
  }

  @override
  SettingsState get initialState => InitialSettingsState();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ToggleThemeEvent) {
      final newBrightness = _toggleTheme(event.context);
      writeToPrefs(brightness: newBrightness);
      yield currentState.copyWith(brightness: newBrightness);
      return;
    }
    if (event is SetFilterTypeEvent) {
      writeToPrefs(filterType: event.filterType);
      yield currentState.copyWith(filterBy: event.filterType);
      return;
    }
    if (event is SetSortTypeEvent) {
      writeToPrefs(sortType: event.sortType);
      yield currentState.copyWith(sortBy: event.sortType);
    }
  }

  Brightness _toggleTheme(BuildContext context) {
    Brightness newBrightness = Theme.of(context).brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    DynamicTheme.of(context).setBrightness(newBrightness);
    return newBrightness;
  }

  String _convertFilterTypeToString(FilterType filterType) {
    switch (filterType) {
      case FilterType.flutter:
        return 'flutter';
      case FilterType.web:
        return 'web';
      case FilterType.all:
      default:
        return 'all';
    }
  }

  String _convertSortTypeToString(SortType sortType) {
    switch (sortType) {
      case SortType.newestPackage:
        return 'newestPackage';
      case SortType.overAllScore:
        return 'overallScore';
      case SortType.recentlyUpdated:
        return 'recentlyUpdated';
      case SortType.popularity:
        return 'popularity';
      case SortType.searchRelevance:
      default:
        return 'relevance';
    }
  }

  String _convertBrightnessToString(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return 'light';
      case Brightness.dark:
      default:
        return 'dark';
    }
  }

  FilterType _convertStringToFilterType(String filterTypeString) {
    switch (filterTypeString) {
      case 'flutter':
        return FilterType.flutter;
      case 'web':
        return FilterType.web;
      case 'all':
      default:
        return FilterType.all;
    }
  }

  SortType _convertStringToSortType(String sortTypeString) {
    switch (sortTypeString) {
      case 'overallScore':
        return SortType.overAllScore;
      case 'recentlyUpdated':
        return SortType.recentlyUpdated;
      case 'newestPackage':
        return SortType.newestPackage;
      case 'popularity':
        return SortType.popularity;
      case 'relevance':
      default:
        return SortType.searchRelevance;
    }
  }

  Brightness _convertStringToBrightness(String brightnessString) {
    switch (brightnessString) {
      case 'light':
        return Brightness.light;
      case 'dark':
      default:
        return Brightness.dark;
    }
  }

  Future<SettingsState> loadFromPrefs(SettingsState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String feedSortSelection = prefs.get('feedSortSelection');
    String feedFilterSelection = prefs.get('feedFilterSelection');
    SortType sortType = _convertStringToSortType(feedSortSelection);
    FilterType filterType = _convertStringToFilterType(feedFilterSelection);
    String brightnessString = prefs.get('brightness');
    Brightness brightness = _convertStringToBrightness(brightnessString);

    return state.copyWith(
      brightness: brightness,
      sortBy: sortType,
      filterBy: filterType,
    );
  }

  void writeToPrefs({
    FilterType filterType,
    SortType sortType,
    Brightness brightness,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (filterType != null) {
      prefs.setString('filterType', _convertFilterTypeToString(filterType));
    }
    if (sortType != null) {
      prefs.setString('filterType', _convertSortTypeToString(sortType));
    }
    if (brightness != null) {
      prefs.setString('filterType', _convertBrightnessToString(brightness));
    }
  }
}
