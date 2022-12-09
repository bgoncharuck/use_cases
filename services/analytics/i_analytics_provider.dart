import 'dart:async';

import '/services/analytics/analytics_property.dart';
import '/services/analytics/i_analytics_event.dart';

abstract class IAnalyticsProvider {
  final _analyticsEventsController = StreamController<IAnalyticsEvent>();
  final _analyticsPropertiesController = StreamController<List<AnalyticsProperty>>();
  Function(IAnalyticsEvent) get addEvent => _analyticsEventsController.sink.add;
  Function(List<AnalyticsProperty>) get addProperties => _analyticsPropertiesController.sink.add;
  bool initialized = false;
  bool get isNotInitialized => !initialized;

  late Future Function(IAnalyticsEvent event) eventsHandler;
  late Future Function(List<AnalyticsProperty> properties) propertiesHandler;

  Future init() async {
    if (isNotInitialized) {
      _analyticsEventsController.stream.listen(eventsHandler);
      _analyticsPropertiesController.stream.listen(propertiesHandler);
      await initUserProperties();
      initialized = true;
    }
  }

  Future dispose() async {
    if (!_analyticsEventsController.isClosed) {
      await _analyticsEventsController.close();
    }
    if (!_analyticsPropertiesController.isClosed) {
      await _analyticsPropertiesController.close();
    }
  }

  Future initUserProperties() async {
    await setUserIdFromLocal();
    await setPropertyFromLocal('locale');
  }

  Future defaultPropertiesHandler(List<AnalyticsProperty> properties) async {
    for (final property in properties) {
      if (property.name == 'id') {
        updateUserId(property.value);
      } else {
        updateProperty(name: property.name, value: property.value);
      }
    }
  }

  Future setUserIdFromLocal();
  Future updateUserId(String id);
  Future setPropertyFromLocal(String name);
  Future updateProperty({required String name, required String value});
}
