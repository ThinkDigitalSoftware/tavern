import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class Cache<KeyType, ValueType> with MapMixin<KeyType, ValueType> {
  Box box;
  static int _writeToPersistentCacheCount = 0;
  static int _writeToLocalCacheCount = 0;

  final Map<KeyType, DateTime> _lastFetched = {};
  Map<KeyType, ValueType> _cache;

  /// A function that will convert the KeyType to a String for storing
  String Function(KeyType) keyToString;
  dynamic Function(ValueType) valueToJsonEncodable;
  ValueType Function(dynamic) valueFromJsonEncodable;

  /// Determines if persistent storage should be used. If false, the cache is deleted
  /// when the app is closed. Defaults to false.
  final bool shouldPersist;

  Cache({
    this.keyToString,
    this.valueToJsonEncodable,
    this.valueFromJsonEncodable,
    this.shouldPersist = false,
  }) {
    if (KeyType == String) {
      keyToString = (key) => key as String;
    }
    if (shouldPersist) {
      if (KeyType != String) {
        assert(keyToString != null);
        assert(valueToJsonEncodable != null);
        assert(valueFromJsonEncodable != null);
      }

      initialize();
    } else {
      _cache = {};
    }
  }

  Future setLastFetched(key, DateTime time) async {
    _lastFetched[key] = time;
    if (shouldPersist) {
      await box.put(
        'lastFetched',
        _lastFetched.map<String, DateTime>(
          (key, time) => MapEntry(keyToString(key), time),
        ),
      );
    }
  }

  DateTime getLastFetched(KeyType key) {
    if (shouldPersist) {
      return DateTime.fromMillisecondsSinceEpoch(
          (box.get('lastFetched') as Map)[keyToString(key)]);
    } else {
      return _lastFetched[key];
    }
  }

  @override
  operator [](Object key) {
    ValueType value;
    if (shouldPersist) {
      final json = box.get(key);

      value = valueFromJsonEncodable(json);
      debugPrint('Returning ${value.runtimeType} from persistant cache.');
    } else {
      value = _cache[key];
      debugPrint('Returning ${value.runtimeType} $key from cache');
    }
    return value;
  }

  @override
  void operator []=(key, value) {
    if (shouldPersist) {
      _writeToPersistentCacheCount++;
      var jsonEncodable = valueToJsonEncodable(value);
      assert(box.isOpen);
      box.put(keyToString(key), jsonEncodable);
    } else {
      _writeToLocalCacheCount++;
      _cache[key] = value;
      debugPrint('Writing ${value.runtimeType} to cache.');
    }
    setLastFetched(key, DateTime.now());

    // debug output throttling
    if (_writeToPersistentCacheCount > 5) {
      debugPrint(
          'Writing $_writeToPersistentCacheCount ${ValueType.toString()}s to persistant cache.');
    }
    if (_writeToLocalCacheCount > 5) {
      debugPrint(
          'Writing $_writeToLocalCacheCount ${ValueType.toString()}s to local cache.');
    }
    _writeToLocalCacheCount = 0;
    _writeToPersistentCacheCount = 0;
  }

  @override
  void clear() => box?.clear();

  @override
  Iterable<KeyType> get keys => throw UnimplementedError();

  @override
  remove(Object key) {
    assert(box.isOpen);
    final value = box.get(keyToString(key));
    box.delete(keyToString(key));
    return value;
  }

  void add(KeyType key, ValueType value) {
    this[key] = value;
  }

  @override
  bool containsKey(Object key) {
    if (key is! KeyType) {
      throw TypeError();
    }
    if (shouldPersist) {
      assert(box?.isOpen ?? false);
      return box.containsKey(key);
    } else {
      return _cache.containsKey(key);
    }
  }

  Future initialize() async {
    var applicationsDocumentDirectory =
        await getApplicationDocumentsDirectory();
    var hiveBoxPath = '${applicationsDocumentDirectory.path}';
    box = await Hive.openBox(ValueType.toString(), path: hiveBoxPath);
  }
}
