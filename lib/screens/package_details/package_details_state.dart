import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
class PackageDetailsState {
  final FullPackage package;

  PackageDetailsState({
    @required this.package,
  }) {
    if (this is! InitialPackageDetailsState) {
      assert(package != null);
    }
  }
}

class InitialPackageDetailsState extends PackageDetailsState {}
