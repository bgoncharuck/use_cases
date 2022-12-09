import 'package:flutter/foundation.dart';

@immutable
class AnalyticsProperty {
  const AnalyticsProperty({this.name = '', this.value = ''});
  final String name;
  final String value;

  bool get isEmpty => name.isEmpty;

  bool get isNotEmpty => name.isNotEmpty;
}
