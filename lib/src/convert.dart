import 'package:flutter/material.dart';
import 'package:pub_client/pub_client.dart';

String convertFilterTypeToString(FilterType filterType) {
  switch (filterType) {
    case FilterType.flutter:
      return 'flutter';
    case FilterType.web:
      return 'web';
    case FilterType.all:
    default:
      return 'all';
  }
}

String convertSortTypeToString(SortType sortType) {
  switch (sortType) {
    case SortType.newestPackage:
      return 'newestPackage';
    case SortType.overAllScore:
      return 'overallScore';
    case SortType.recentlyUpdated:
      return 'recentlyUpdated';
    case SortType.popularity:
      return 'popularity';
    case SortType.searchRelevance:
    default:
      return 'relevance';
  }
}

String convertBrightnessToString(Brightness brightness) {
  switch (brightness) {
    case Brightness.light:
      return 'light';
    case Brightness.dark:
    default:
      return 'dark';
  }
}

FilterType convertStringToFilterType(String filterTypeString) {
  switch (filterTypeString) {
    case 'flutter':
      return FilterType.flutter;
    case 'web':
      return FilterType.web;
    case 'all':
    default:
      return FilterType.all;
  }
}

SortType convertStringToSortType(String sortTypeString) {
  switch (sortTypeString) {
    case 'overallScore':
      return SortType.overAllScore;
    case 'recentlyUpdated':
      return SortType.recentlyUpdated;
    case 'newestPackage':
      return SortType.newestPackage;
    case 'popularity':
      return SortType.popularity;
    case 'relevance':
    default:
      return SortType.searchRelevance;
  }
}

Brightness convertStringToBrightness(String brightnessString) {
  switch (brightnessString) {
    case 'light':
      return Brightness.light;
    case 'dark':
    default:
      return Brightness.dark;
  }
}
