import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileDownloadService {
  FileDownloadService._();
  static FileDownloadService? _instance;
  static FileDownloadService get instance {
    return _instance ??= FileDownloadService._();
  }

  final Map<String, String> _filePath = {};

  Future<bool> downloadFile(String url) async {
    final fileName = _getFileNameFromUrl(url);
    final savePath = await _getSavePath(fileName);

    /// checks if file already exists, first inside the map, then using existsSync
    if (await doesFileExist(url)) {
      return true;
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return false;
    }

    final file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);
    _filePath[fileName] = savePath;
    return true;
  }

  String? getFilePathByUrl(String url) {
    final fileName = _getFileNameFromUrl(url);
    return _filePath[fileName];
  }

  String? getFilePathByFileName(String fileName) {
    return _filePath[fileName];
  }

  Future<bool> doesFileExist(String url) async {
    final filePathFromMap = getFilePathByUrl(url);
    if (filePathFromMap != null) {
      return true;
    }

    final fileName = _getFileNameFromUrl(url);
    final savePath = await _getSavePath(fileName);
    final exists = File(savePath).existsSync();
    if (!exists) {
      return false;
    }

    _filePath[fileName] = savePath;
    return true;
  }

  Future<bool> doFilesExist(Iterable<String> urls) async {
    for (final url in urls) {
      final exist = await doesFileExist(url);
      if (!exist) {
        return false;
      }
    }
    return true;
  }

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

  Future<String> _getSavePath(String fileName) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return '${appDocDir.path}/$fileName';
  }

  String _getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments.last;
  }
}
