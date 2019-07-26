import 'dart:collection';

import 'package:flutter/material.dart';

abstract class Cache<KeyType, ValueType> with MapMixin<KeyType, ValueType> {
  final Map<KeyType, ValueType> _cache = {};
  Map<KeyType, DateTime> lastFetched = {};

  @override
  operator [](Object key) {
    ValueType value = _cache[key];
    debugPrint('Returning ${value.runtimeType} $key from cache');
    return value;
  }

  @override
  void operator []=(key, value) {
    lastFetched[key] = DateTime.now();
    _cache[key] = value;
  }

  @override
  void clear() => _cache.clear();

  @override
  Iterable<KeyType> get keys => _cache.keys;

  @override
  remove(Object key) => _cache.remove(key);

  void add(KeyType key, ValueType value) => this[key] = value;

  @override
  bool containsKey(Object key) {
    if (key is! KeyType) {
      throw TypeError();
    }
    return super.containsKey(key);
  }
}
