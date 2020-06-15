import 'package:flutter/material.dart' hide Page;
import 'package:meta/meta.dart';
import 'package:pub_client/pub_client.dart';
import 'package:tavern/src/convert.dart';

@immutable
class PublisherState {
  final Page page;
  final String publisherName;

  const PublisherState({
    @required this.page,
    @required this.publisherName,
  });

  PublisherState copyWith({Page page, String publisherName}) {
    return PublisherState(
      page: page ?? this.page,
      publisherName: publisherName ?? this.publisherName,
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page?.toJson(),
      };

  factory PublisherState.fromJson(Map<String, dynamic> json) {
    return PublisherState(
        page: Page.fromJson(json['page']),
        publisherName: json['publisherName'] ?? "");
  }
}

class InitialPublisherState extends PublisherState {
  final String publisherN;
  const InitialPublisherState(this.publisherN)
      : super(page: null, publisherName: publisherN
            //"firebase.google.com",
            );
}
