import '/services/analytics/user_properties.dart';
import '/services/analytics/providers/amplitude.dart';
import '/services/analytics/providers/google.dart';

import 'i_analytics_event.dart';
import 'i_analytics_provider.dart';

class AnalyticsObserver {
  final IAnalyticsProvider amplitude = AmplitudeAnalyticsProvider();
  final IAnalyticsProvider google = GoogleAnalyticsProvider();

  Future initAll() async {
    if (amplitude.isNotInitialized) {
      await amplitude.init();
    }
    if (google.isNotInitialized) {
      await google.init();
    }
  }

  Future disposeAll() async {
    await amplitude.dispose();
    await google.dispose();
  }

  Future event(IAnalyticsEvent event) async {
    if (event.config.skip) {
      return;
    }
    if (amplitude.initialized) {
      await amplitude.addEvent(event);
    }
    if (google.initialized) {
      await google.addEvent(event);
    }
  }

  Future properties(List<AnalyticsProperty> properties) async {
    for (final property in properties) {
      UserProperties()[property.name] = property.value;
    }
    if (amplitude.initialized) {
      await amplitude.addProperties(properties);
    }
    if (google.initialized) {
      await google.addProperties(properties);
    }
  }
}
