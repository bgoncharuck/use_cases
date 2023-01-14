import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'i_use_case.dart';
import '/services/analytics/analytics.dart';
import 'package:permission_handler/permission_handler.dart';

class AskPermissions with IUseCase<bool, AskPermissionsParams> {
  const AskPermissions();

  @override
  Future<bool> execute({required AskPermissionsParams params}) async {
    if (params.requiredPerms.isEmpty && params.optionalPerms.isEmpty) {
      return true;
    }

    final Map<String, String> analyticsStatus = {};

    final Map<Permission, bool> requiredStatus = {};
    for (final permission in params.requiredPerms) {
      requiredStatus[permission] = await requiredPermissionRequest(permission);
      analyticsStatus[permission.toString()] = requiredStatus[permission]! ? 'yes' : 'no';
    }

    for (final permission in params.optionalPerms) {
      analyticsStatus[permission.toString()] = await optionalPermissionRequest(permission) ? 'yes' : 'no';
    }

    Get.find<AnalyticsObserver>().event(
      DefaultAnalyticsEvent(
        name: 'permissions_request',
        screen: params.fromScreen,
        category: AnalyticsCategory.general,
        properties: analyticsStatus,
      ),
    );

    if (requiredStatus.isEmpty) {
      return true;
    }
    return requiredStatus.values.every((granted) => granted);
  }
}

class AskPermissionsParams {
  const AskPermissionsParams({
    this.requiredPerms = const <Permission>[],
    this.optionalPerms = const <Permission>[],
    required this.fromScreen,
  });
  final List<Permission> requiredPerms;
  final List<Permission> optionalPerms;
  final String fromScreen;
}

Future<bool> checkPermissions(List<Permission> permissions) async {
  bool result = true;
  for (final perm in permissions) {
    if (permissionIsGranted(await perm.status) == false) {
      result = false;
    }
  }
  return result;
}

bool permissionIsGranted(PermissionStatus status) {
  return status == PermissionStatus.granted || status == PermissionStatus.limited;
}

Future<bool> optionalPermissionRequest(Permission permission) async {
  try {
    final status = await permission.status;
    if (permissionIsGranted(status)) {
      return true;
    } else if (status == PermissionStatus.denied) {
      return permissionIsGranted(await permission.request());
    }
  } catch (e, t) {
    Sentry.captureException(e, stackTrace: t);
  }
  return false;
}

Future<bool> requiredPermissionRequest(Permission permission) async {
  try {
    final status = await permission.status;
    if (permissionIsGranted(status)) {
      return true;
    } else if (status == PermissionStatus.denied) {
      return permissionIsGranted(await permission.request());
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      return false;
    }
  } catch (e, t) {
    Sentry.captureException(e, stackTrace: t);
  }
  return false;
}
