import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

abstract class DownloadService {
  Future<bool> downloadFile(String url);
  String? getPathByUrl(String url);
  String? getPathByFileName(String fileName);
  Future<bool> doesFileExist(String url);
  Future<bool> doFilesExist(Iterable<String> urls);
  Future<bool> downloadMultipleFiles(Iterable<String> urls);
  Future<File?> loadFile(String fileName);
}

class DefaultDownloadService implements DownloadService {
  DefaultDownloadService._();
  static DefaultDownloadService? _instance;
  static DefaultDownloadService get instance {
    return _instance ??= DefaultDownloadService._();
  }

  final Map<String, String> _filePath = {};

  @override
  Future<bool> downloadFile(String url) async {
    final filePath = _getFilePathFromUrl(url);
    final savePath = await _getSavePath(filePath);

    /// checks if file already exists, first inside the map, then using existsSync
    if (await doesFileExist(url)) {
      return true;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return false;
      }

      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      _filePath[filePath] = savePath;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  String? getPathByUrl(String url) {
    final filePath = _getFilePathFromUrl(url);
    return _filePath[filePath];
  }

  @override
  String? getPathByFileName(String fileName) {
    return _filePath[fileName];
  }

  @override
  Future<bool> doesFileExist(String url) async {
    final filePathFromMap = getPathByUrl(url);
    if (filePathFromMap != null) {
      return true;
    }

    final filePath = _getFilePathFromUrl(url);
    final savePath = await _getSavePath(filePath);
    final exists = File(savePath).existsSync();
    if (!exists) {
      return false;
    }

    _filePath[filePath] = savePath;
    return true;
  }

  @override
  Future<bool> doFilesExist(Iterable<String> urls) async {
    for (final url in urls) {
      final exist = await doesFileExist(url);
      if (!exist) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<bool> downloadMultipleFiles(Iterable<String> urls) async {
    final futures = <Future<bool>>[];
    for (final url in urls) {
      futures.add(downloadFile(url));
    }
    final results = await Future.wait(futures);

    for (final result in results) {
      if (!result) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<File?> loadFile(String fileName) async {
    final filePath = await _getSavePath(fileName);

    final file = File(filePath);
    if (file.existsSync()) {
      return file;
    }

    return null;
  }

  Future<String> _getSavePath(String filePath) async {
    final appDocDir = await getApplicationDocumentsDirectory();

    final fullPath = '${appDocDir.path}/$filePath';
    final directoryPath = fullPath.substring(0, fullPath.lastIndexOf('/'));
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    return fullPath;
  }

  String _getFilePathFromUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    final subPathSegments = pathSegments.sublist(1, pathSegments.length - 1);
    final subPath = subPathSegments.join('/');
    return '/$subPath/${uri.pathSegments.last}';
  }
}
