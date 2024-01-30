part of 'file_path.dart';

Future<bool> copyFile({
  required String sourcePath,
  required String destinationPath,
}) async {
  final FileSystemEntity destination = File(destinationPath);

  if (destination is Directory) {
    return false;
  }

  await File(sourcePath).copy(destinationPath);
  return true;
}

Future<bool> moveFile({
  required String sourcePath,
  required String destinationPath,
}) async {
  final FileSystemEntity destination = File(destinationPath);

  if (destination is Directory) {
    return false;
  }

  try {
    await File(sourcePath).rename(destinationPath);
  } on Exception catch (e, t) {
    await log.exception(e, t);
    final source = File(sourcePath);
    await source.copy(destinationPath);
    await source.delete();
  }
  return true;
}


bool deleteFolderIfExistByPath({required String path}) {
    final Directory directory = Directory(path);
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
    return true;
  }

  void renameFolderToAnotherName({required String sourcePath, required String destinationPath}) {
    Directory(sourcePath).renameSync(destinationPath);
  }

  bool deleteFileIfExistByPath({required String path}) {
    final File file = File(path);
    if (file.existsSync()) {
      file.deleteSync(recursive: true);
    }
    return true;
  }
