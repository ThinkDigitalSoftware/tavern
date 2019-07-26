import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/src/convert.dart';

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

  Future<SettingsState> loadFromPrefs(SettingsState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String feedSortSelection = prefs.get('feedSortSelection');
    String feedFilterSelection = prefs.get('feedFilterSelection');
    SortType sortType = convertStringToSortType(feedSortSelection);
    FilterType filterType = convertStringToFilterType(feedFilterSelection);
    String brightnessString = prefs.get('brightness');
    Brightness brightness = convertStringToBrightness(brightnessString);

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
      prefs.setString('filterType', convertFilterTypeToString(filterType));
    }
    if (sortType != null) {
      prefs.setString('filterType', convertSortTypeToString(sortType));
    }
    if (brightness != null) {
      prefs.setString('filterType', convertBrightnessToString(brightness));
    }
  }
}
