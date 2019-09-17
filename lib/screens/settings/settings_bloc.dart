import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tavern/screens/bloc.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  @override
  SettingsState get initialState => InitialSettingsState();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ToggleThemeEvent) {
      final newBrightness = _toggleTheme(event.context);
      yield currentState.copyWith(brightness: newBrightness);
      return;
    }
    if (event is SetFilterTypeEvent) {
      yield currentState.copyWith(filterBy: event.filterType);
      return;
    }
    if (event is SetSortTypeEvent) {
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

  @override
  SettingsState fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SettingsState state) => state.toJson();
}
