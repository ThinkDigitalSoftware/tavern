import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_event.dart';
import 'package:tavern/src/cache.dart';

class PackageDetailsBloc
    extends Bloc<PackageDetailsEvent, PackageDetailsState> {
  final PubHtmlParsingClient client;
  final PackageRepository _packageRepository;

  PackageDetailsBloc({@required this.client})
      : _packageRepository = PackageRepository(client: client);

  @override
  PackageDetailsState get initialState => InitialPackageDetailsState();

  @override
  Stream<PackageDetailsState> mapEventToState(
    PackageDetailsEvent event,
  ) async* {
    if (event is GetPackageDetailsEvent) {
      FullPackage package = await _packageRepository.get(event.packageName);

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

class PackageCache<String, Package> extends Cache {}

class PackageRepository {
  final PubHtmlParsingClient client;
  final PackageCache<String, FullPackage> _packageCache = PackageCache();

  PackageRepository({@required this.client});

  Future<FullPackage> get(String packageName) async {
    if (_packageCache.containsKey(packageName)) {
      return _packageCache[packageName];
    } else {
      FullPackage package = await client.get(packageName);
      _packageCache.add(packageName, package);
      return package;
    }
  }
}
