import 'dart:async';

import 'package:meta/meta.dart';

@immutable
abstract class PackageDetailsEvent {}

class GetPackageDetailsEvent extends PackageDetailsEvent {
  final String packageName;
  final Completer onComplete = Completer();

  GetPackageDetailsEvent({
    @required this.packageName,
  }) : assert(packageName != null);
}

class InitializePackageDetailsBloc extends PackageDetailsEvent {}
