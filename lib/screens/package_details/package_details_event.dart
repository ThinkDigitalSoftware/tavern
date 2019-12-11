import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
abstract class PackageDetailsEvent {}

class GetPackageDetailsEvent extends PackageDetailsEvent {
  final Package package;
  final Completer onComplete = Completer();

  GetPackageDetailsEvent({
    @required this.package,
  }) : assert(package != null);
}

class InitializePackageDetailsBloc extends PackageDetailsEvent {}
