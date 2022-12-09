import 'package:flutter/foundation.dart';
import 'analytics_property.dart';
export 'analytics_property.dart';

const String defaultCategoryPropertyName = 'event_category';
const String defaultScreenPropertyName = 'screen';
// const String defaultPreviousScreenPropertyName = 'previous_screen';

@immutable
class AnalyticsConfig {
  const AnalyticsConfig({this.global = const {}, this.provider = const {}, this.skip = false});
  final Map<String, dynamic> global;
  final Map<String, dynamic> provider;
  final bool skip;

  bool get isEmpty => global.isEmpty && provider.isEmpty && skip == false;

  bool get isNotEmpty => global.isNotEmpty && provider.isNotEmpty && skip == true;
}

abstract class IAnalyticsEvent {
  String get name;
  Map<String, String> get properties;
  AnalyticsProperty get category;
  AnalyticsProperty get screen;
  AnalyticsConfig get config;
}
