import 'package:shorebird_code_push/shorebird_code_push.dart';

ShorebirdCodePush? _shorebird;
bool _updateAvailable = false;

Future<void> initialize() async {
  _shorebird = ShorebirdCodePush();
}

Future<int?> getAppVersionOrNull() async {
  assert(_shorebird != null, 'UpdatesService not initialized. Call initialize() first.');
  return await _shorebird!.currentPatchNumber();
}

Future<bool> updateAvilable() async {
  assert(_shorebird != null, 'UpdatesService not initialized. Call initialize() first.');
  return _updateAvailable = await _shorebird!.isNewPatchAvailableForDownload();
}

Future<bool> downloadUpdate() async {
  assert(_shorebird != null, 'UpdatesService not initialized. Call initialize() first.');

  if (!_updateAvailable) {
    return false;
  }
  await _shorebird!.downloadUpdateIfAvailable();
  return true;
}

Future<bool> updateWillBeInstalledOnNextLaunch() async {
  assert(_shorebird != null, 'UpdatesService not initialized. Call initialize() first.');
  return await _shorebird!.isNewPatchReadyToInstall();
}

/// example

Future<void> applyPatch() {
  final appVersion = await getAppVersionOrNull();
  final updatesAvailable = await updateAvilable();
  if (appVersion == null || updatesAvailable) {
    await downloadUpdate();
  }

  if (await updateWillBeInstalledOnNextLaunch()) {
    /// restart, give user message about pending update or just wait next launch
  }
  else {
    /// your app is updated with latest patch
  }
}
