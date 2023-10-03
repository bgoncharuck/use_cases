import 'package:app_tracking_transparency/app_tracking_transparency.dart';

Future<String> getIDFAId() async {
  final status = await AppTrackingTransparency.requestTrackingAuthorization();

  if (status == TrackingStatus.authorized) {
    return await AppTrackingTransparency.getAdvertisingIdentifier();
  } else {
    return 'TrackingStatus ${status.name}';
  }
}
