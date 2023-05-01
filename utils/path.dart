String dirname(String path) {
  final file = path.split("/").last;
  return path.replaceFirst('/$file', '');
}
