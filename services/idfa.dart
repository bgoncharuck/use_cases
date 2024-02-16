import 'package:app_tracking_transparency/app_tracking_transparency.dart';

Future<String> getIDFAId() async {
  try {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();

    if (status == TrackingStatus.authorized) {
      return await AppTrackingTransparency.getAdvertisingIdentifier();
    } else {
      return 'TrackingStatus ${status.name}';
    }
  } catch (e, t) {
    await Sentry.captureException(e, stackTrace: t);
    return 'TrackingStatus restricted';
  }
}

int getStatusInteger(String status) {
  switch (status) {
    case 'TrackingStatus notDetermined':
      return 0;
    case 'TrackingStatus restricted':
      return 1;
    case 'TrackingStatus denied':
      return 2;
    case 'TrackingStatus authorized':
      return 3;
    default:
      return -1;
  }
}
