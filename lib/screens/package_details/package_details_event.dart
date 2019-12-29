import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';

@immutable
abstract class PackageDetailsEvent {
  final Package package;

  const PackageDetailsEvent(this.package);
}

class GetPackageDetailsEvent extends PackageDetailsEvent {
  final Completer onComplete = Completer();

  GetPackageDetailsEvent({
    @required Package package,
  })  : assert(package != null),
        super(package);
}

class InitializePackageDetailsBloc extends PackageDetailsEvent {
  const InitializePackageDetailsBloc() : super(null);
}
