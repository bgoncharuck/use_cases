import 'package:get/get.dart';

import 'i_use_case.dart';
import '/services/analytics/analytics.dart';
import 'package:permission_handler/permission_handler.dart';

class AskPermissions with IUseCase<bool, AskPermissionsParams> {
  const AskPermissions();

  @override
  Future<bool> execute({required AskPermissionsParams params}) async {
    if (params.permissions.isEmpty) {
      return true;
    }

    final Map<Permission, bool> status = {};
    final Map<String, String> analyticsStatus = {};
    for (final permission in params.permissions) {
      status[permission] = permissionIsGranted(await permission.request());
      analyticsStatus[permission.toString()] = status[permission]! ? 'yes' : 'no';
    }

    Get.find<AnalyticsObserver>().event(
      DefaultAnalyticsEvent(
        name: 'permissions_request',
        screen: params.fromScreen,
        category: AnalyticsCategory.general,
        properties: analyticsStatus,
      ),
    );

    return status.values.every((granted) => granted);
  }

  bool permissionIsGranted(PermissionStatus status) {
    return status == PermissionStatus.granted || status == PermissionStatus.limited;
  }
}

class AskPermissionsParams {
  const AskPermissionsParams({
    required this.permissions,
    required this.fromScreen,
  });
  final List<Permission> permissions;
  final String fromScreen;
}
