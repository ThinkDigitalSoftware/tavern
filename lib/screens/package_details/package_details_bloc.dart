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
  final PackageRepository _packageRepository;

  PackageDetailsBloc() : _packageRepository = GetIt.I.get<PackageRepository>();

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
    if (event is InitializePackageDetailsBloc) {
      yield InitialPackageDetailsState();
      return;
    }
  }
}

class PackageCache extends Cache<String, Package> {}

class FullPackageCache extends Cache<String, FullPackage> {}

class PackageRepository extends Repository<String, FullPackage> {
  final PubHtmlParsingClient client;
  final FullPackageCache _packageCache = FullPackageCache();

  PackageRepository({@required this.client});

  Future<FullPackage> get(String query) async {
    if (_packageCache.containsKey(query)) {
      return _packageCache[query];
    } else {
      FullPackage package = await client.get(query);
      _packageCache.add(query, package);
      return package;
    }
  }
}
