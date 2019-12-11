import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/screens/bloc.dart';
import 'package:tavern/screens/package_details/package_details_event.dart';
import 'package:tavern/src/cache.dart';
import 'package:tavern/src/repository.dart';

class PackageDetailsBloc
    extends Bloc<PackageDetailsEvent, PackageDetailsState> {
  Package package;
  final FullPackageRepository _packageRepository;

  PackageDetailsBloc({@required this.package})
      : _packageRepository = GetIt.I.get<FullPackageRepository>() {
    add(
      GetPackageDetailsEvent(package: package),
    );
  }

  @override
  PackageDetailsState get initialState =>
      InitialPackageDetailsState(package.name);

  @override
  Stream<PackageDetailsState> mapEventToState(
    PackageDetailsEvent event,
  ) async* {
    try {
      if (event is GetPackageDetailsEvent) {
        FullPackage package =
            await _packageRepository.getFromPackage(event.package);

        yield PackageDetailsState(package: package);
        FullPackage newerPackage =
            await _packageRepository.getIfNewer(event.package);
        if (newerPackage != null) {
          debugPrint(
              '${event.package} has been updated since your last query. Updating');
          yield PackageDetailsState(package: newerPackage);
        }
        event.onComplete.complete();
        return;
      }
      if (event is InitializePackageDetailsBloc) {
        // yield InitialPackageDetailsState();
        return;
      }
    } on Exception catch (e) {
      yield PackageDetailsErrorState(
        e,
        package: package,
      );
    }
  }
}

class PackageCache extends Cache<String, Package> {
  PackageCache()
      : super(
          shouldPersist: true,
          valueToJsonEncodable: (package) => package.toJson(),
          valueFromJsonEncodable: (json) => Package.fromJson(json),
        ) {
    getIt.registerSingleton<PackageCache>(this);
  }
}

class FullPackageCache extends Cache<String, FullPackage> {
  FullPackageCache()
      : super(
          shouldPersist: true,
          valueToJsonEncodable: (fullPackage) => fullPackage?.toJson(),
          valueFromJsonEncodable: (json) =>
              FullPackage.fromJson((json as Map)?.cast<String, dynamic>()),
        ) {
    getIt.registerSingleton<FullPackageCache>(this);
  }
}

class FullPackageRepository extends Repository<String, FullPackage> {
  final PubHtmlParsingClient client;
  final FullPackageCache _packageCache = FullPackageCache();

  FullPackageRepository({@required this.client});

  Future<FullPackage> get(String query) async {
    if (_packageCache.containsKey(query)) {
      return _packageCache[query];
    } else {
      FullPackage package = await client.get(query);
      _packageCache.add(query, package);
      return package;
    }
  }

  Future<FullPackage> getFromPackage(Package package) async {
    if (_packageCache.containsKey(package.name)) {
      return _packageCache[package.name];
    } else {
      FullPackage fullPackage = await package.toFullPackage();
      _packageCache.add(package.name, fullPackage);
      return fullPackage;
    }
  }

  /// Runs a get call just like [get], but only returns a value if the package
  /// has been updated since the last [get] call, otherwise, it returns null.
  Future<FullPackage> getIfNewer(Package package) async {
    FullPackage oldPackage = _packageCache[package.name];
    assert(oldPackage != null,
        "This function should be run AFTER get so oldPackage should not return null");
    FullPackage newPackage = await package.toFullPackage();

    if (newPackage is DartLibraryFullPackage) {
      return null;
    }

    if (newPackage.latestSemanticVersion > oldPackage.latestSemanticVersion) {
      _packageCache.add(package.name, newPackage);
      return newPackage;
    } else {
      return null;
    }
  }
}
