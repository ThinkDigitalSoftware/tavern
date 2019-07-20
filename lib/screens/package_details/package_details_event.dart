import 'dart:async';

import 'package:meta/meta.dart';

@immutable
abstract class PackageDetailsEvent {}

class GetPackageDetailsEvent extends PackageDetailsEvent {
  final String packageName;
  final int packageScore;
  final Completer onComplete = Completer();

  GetPackageDetailsEvent({
    @required this.packageName,
    @required this.packageScore,
  }) : assert(packageName != null);
}

class Initialize extends PackageDetailsEvent {}
