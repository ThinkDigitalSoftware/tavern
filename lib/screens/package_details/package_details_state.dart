import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
class PackageDetailsState {
  final FullPackage package;

  PackageDetailsState({
    @required this.package,
  }) {
    assert(package != null);
  }
}

class InitialPackageDetailsState extends PackageDetailsState {
  InitialPackageDetailsState(String packageName)
      : super(package: FullPackage(name: packageName, url: null, author: null));
}

class PackageDetailsErrorState extends PackageDetailsState {
  final Exception error;

  PackageDetailsErrorState(this.error, {@required dynamic package})
      : super(package: toFullPackage(package));

  static FullPackage toFullPackage(dynamic package) {
    if (package is FullPackage) {
      return package;
    }
    if (package is Package) {
      return FullPackage(
          name: package.name, url: package.packageUrl, author: '');
    }
    throw UnsupportedError(
        "Object of type ${package.runtimeType} is not supported");
  }
}
