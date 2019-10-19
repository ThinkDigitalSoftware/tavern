import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';

@immutable
abstract class SettingsEvent {}

class ToggleThemeEvent extends SettingsEvent {
  final BuildContext context;

  ToggleThemeEvent({@required this.context}) : assert(context != null);
}

class SetFilterTypeEvent extends SettingsEvent {
  final FilterType filterType;

  SetFilterTypeEvent({@required this.filterType}) : assert(filterType != null);
}

class SetSortTypeEvent extends SettingsEvent {
  final SortType sortType;

  SetSortTypeEvent({@required this.sortType}) : assert(sortType != null);
}

class ChangeStateEvent extends SettingsEvent {
  final SettingsState state;

  ChangeStateEvent({@required this.state}) : assert(state != null);
}

class AuthenticateWithGithub extends SettingsEvent {
  final String username;
  final String password;

  AuthenticateWithGithub({
    @required this.username,
    @required this.password,
  }) : assert(username != null && password != null);
}

class CheckAuth extends SettingsEvent {}
