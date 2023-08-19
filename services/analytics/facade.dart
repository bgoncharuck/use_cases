import '/services/analytics/user_properties.dart';
import '/services/analytics/providers/amplitude.dart';
import '/services/analytics/providers/google.dart';

import 'i_analytics_event.dart';
import 'i_analytics_provider.dart';

class AnalyticsFacade {
  final IAnalyticsProvider amplitude = AmplitudeAnalyticsProvider();
  final IAnalyticsProvider google = GoogleAnalyticsProvider();

  Future<void> initializeProviders() async {
    if (amplitude.isNotInitialized) {
      await amplitude.initialize();
    }
    if (google.isNotInitialized) {
      await google.initialize();
    }
  }

  Future<void> disposeProviders() async {
    await amplitude.dispose();
    await google.dispose();
  }

  Future<void> trackEvent(IAnalyticsEvent event) async {
    if (event.config.skip) {
      return;
    }
    if (amplitude.isInitialized) {
      await amplitude.addEvent(event);
    }
    if (google.isInitialized) {
      await google.addEvent(event);
    }
  }

  Future<void> setProperties(List<AnalyticsProperty> properties) async {
    for (final property in properties) {
      UserProperties()[property.name] = property.value;
    }
    if (amplitude.isInitialized) {
      await amplitude.addProperties(properties);
    }
    if (google.isInitialized) {
      await google.addProperties(properties);
    }
  }
}
