import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_event.dart';

class PackageDetailsBloc
    extends Bloc<PackageDetailsEvent, PackageDetailsState> {
  final PubHtmlParsingClient client;
  static final _packageCache = PackageCache();

  PackageDetailsBloc({@required this.client});

  @override
  PackageDetailsState get initialState => InitialPackageDetailsState();

  @override
  Stream<PackageDetailsState> mapEventToState(
    PackageDetailsEvent event,
  ) async* {
    if (event is GetPackageDetailsEvent) {
      FullPackage package;
      if (_packageCache.containsKey(event.packageName)) {
        package = _packageCache[event.packageName];
      } else {
        package = await client.get(event.packageName);
        _packageCache[package.name] = package;
      }
      yield PackageDetailsState(package: package);
      event.onComplete.complete();
      return;
    }
    if (event is Initialize) {
      yield InitialPackageDetailsState();
      return;
    }
  }
}

class PackageCache with MapMixin {
  final Map<String, FullPackage> _cache = {};
  Map<String, DateTime> lastFetched = {};

  @override
  operator [](Object key) => _cache[key];

  @override
  void operator []=(key, value) {
    lastFetched[key] = DateTime.now();
    return _cache[key] = value;
  }

  @override
  void clear() => _cache.clear();

  @override
  Iterable get keys => _cache.keys;

  @override
  remove(Object key) => _cache.remove(key);
}
