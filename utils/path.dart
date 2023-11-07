String dirname(String path) {
  final file = path.split("/").last;
  return path.replaceFirst('/$file', '');
}

extension PathExtension on String {
  String fixWith(PathFixerStrategy fixer) {
    return fixer.fix(this);
  }
}

// ignore: one_member_abstracts
abstract class PathFixerStrategy {
  String fix(String path);
}

class DefaultPathFixer implements PathFixerStrategy {
  final PathFixerStrategy emptySpaceFixer = EmptySpacePathFixer();
  final PathFixerStrategy duplicateLangFixer = DuplicateLangPathFixer();
  final PathFixerStrategy duplicateSlashFixer = DuplicateSlashPathFixer();

  @override
  String fix(String path) {
    return path.fixWith(emptySpaceFixer).fixWith(duplicateLangFixer).fixWith(duplicateSlashFixer);
  }
}

class EmptySpacePathFixer implements PathFixerStrategy {
  @override
  String fix(String path) {
    return path.replaceAll('%20', '_').replaceAll(' ', '_');
  }
}

class DuplicateLangPathFixer implements PathFixerStrategy {
  @override
  String fix(String path) {
    final segments = path.split('/');
    final lang = segments.length > 1 ? segments[segments.length - 2] : '';
    return path.replaceAll(RegExp('/$lang/$lang/'), '/$lang/');
  }
}

class DuplicateSlashPathFixer implements PathFixerStrategy {
  @override
  String fix(String path) {
    return path.replaceAll(RegExp('//+'), '/');
  }
}
