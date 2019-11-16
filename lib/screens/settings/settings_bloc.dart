import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:github/github.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  @override
  SettingsState get initialState =>
      super.initialState ?? InitialSettingsState();

  static SettingsBloc of(BuildContext context) =>
      BlocProvider.of<SettingsBloc>(context);

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  SettingsBloc() {
    add(CheckAuth());
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ToggleThemeEvent) {
      final newBrightness = _toggleTheme(event.context);
      yield state.copyWith(brightness: newBrightness);
      return;
    }
    if (event is SetFilterTypeEvent) {
      yield state.copyWith(filterBy: event.filterType);
      return;
    }
    if (event is SetSortTypeEvent) {
      yield state.copyWith(sortBy: event.sortType);
      return;
    }

    if (event is AuthenticateWithGithub) {
      secureStorage.write(key: 'githubUsername', value: event.username);
      secureStorage.write(key: 'githubPassword', value: event.password);

      yield state.copyWith(
        authentication: Authentication.basic(event.username, event.password),
      );
      return;
    }
    if (event is CheckAuth) {
      String username = await secureStorage.read(key: 'githubUsername');
      String password = await secureStorage.read(key: 'githubPassword');
      if (username != null && password != null) {}
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
