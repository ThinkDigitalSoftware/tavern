import 'package:pub_client/pub_client.dart';
import 'package:tavern/src/convert.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("Convert FilterType to String tests", () {
    expect(convertFilterTypeToString(FilterType.flutter), 'flutter');
  });
}
