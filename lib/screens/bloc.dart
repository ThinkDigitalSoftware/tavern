import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

export 'package:tavern/screens/home/home_bloc.dart';
export 'package:tavern/screens/home/home_event.dart';
export 'package:tavern/screens/home/home_state.dart';
export 'package:tavern/screens/package_details/package_details_bloc.dart';
export 'package:tavern/screens/package_details/package_details_event.dart';
export 'package:tavern/screens/package_details/package_details_state.dart';
export 'package:tavern/screens/search/search_bloc.dart';
export 'package:tavern/screens/search/search_event.dart';
export 'package:tavern/screens/search/search_state.dart';
export 'package:tavern/screens/settings/settings_bloc.dart';
export 'package:tavern/screens/settings/settings_event.dart';
export 'package:tavern/screens/settings/settings_state.dart';
export 'package:tavern/screens/subscriptions/subscription_bloc.dart';
export 'package:tavern/screens/subscriptions/subscription_event.dart';
export 'package:tavern/screens/subscriptions/subscription_state.dart';

class TavernBlocDelegate extends HydratedBlocDelegate {
  TavernBlocDelegate(HydratedStorage storage) : super(storage);

  @override
  void onEvent(Bloc bloc, Object event) {
    debugPrint("$event called for $bloc");
    super.onEvent(bloc, event);
  }

  Future<BlocDelegate> build() => HydratedBlocDelegate.build();
}
