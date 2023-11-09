// ignore_for_file: one_member_abstracts

Map<String, String> buildVirtualToRealPathPairs({required List<String> realPaths, required String rootNode}) {
  final virtualPathVisitor = VirtualPathVisitor(rootNode: rootNode);
  final virtualToRealPathPairs = <String, String>{};
  for (final realPath in realPaths) {
    final virtualPath = realPath.visitWith(virtualPathVisitor);
    virtualToRealPathPairs[virtualPath] = realPath;
  }
  return virtualToRealPathPairs;
}

abstract class PathVisitor {
  String visit(String path);
}

extension PathVisitorExtension on String {
  String visitWith(PathVisitor visitor) {
    return visitor.visit(this);
  }
}

class VirtualPathVisitor implements PathVisitor {
  final String rootNode;
  VirtualPathVisitor({required this.rootNode}) {
    prefixCutterVisitor = PrefixCutterPathVisitor(end: rootNode);
    incorrectEmptySpaceVisitor = IncorrectEmptySpaceVisitor();
    filenameHasLangVisitor = FilenameHasLangVisitor();
    noLangSubfolderPathFixer = NoLangSubfolderPathFixer();
    duplicateLangSubfolderVisitor = DuplicateLangSubfolderVisitor();
  }

  late final PathVisitor prefixCutterVisitor;
  late final PathVisitor incorrectEmptySpaceVisitor;
  late final PathVisitor filenameHasLangVisitor;
  late final PathVisitor noLangSubfolderPathFixer;
  late final PathVisitor duplicateLangSubfolderVisitor;

  @override
  String visit(String path) {
    return path
        .visitWith(prefixCutterVisitor)
        .visitWith(incorrectEmptySpaceVisitor)
        .visitWith(filenameHasLangVisitor)
        .visitWith(noLangSubfolderPathFixer)
        .visitWith(duplicateLangSubfolderVisitor);
  }
}

class IncorrectEmptySpaceVisitor implements PathVisitor {
  @override
  String visit(String path) {
    return path.replaceAll('%20', ' ');
  }
}

class FilenameHasLangVisitor implements PathVisitor {
  @override
  String visit(String path) {
    final segments = path.split('/');
    final filename = segments.last;
    var lang = '';

    for (final langCode in languageCodesProvider.validLangCodes) {
      if (filename.toLowerCase().contains(langCode)) {
        lang = langCode;
        break;
      }
    }

    if (lang == '') {
      return path;
    }

    final langIndex = filename.toLowerCase().indexOf(lang);
    segments
      ..last = filename.substring(0, langIndex) + filename.substring(langIndex + lang.length)
      ..insert(segments.length - 1, lang);

    return segments.join('/');
  }
}

class NoLangSubfolderPathFixer implements PathVisitor {
  @override
  String visit(String path) {
    final segments = path.split('/');

    for (final langCode in languageCodesProvider.validLangCodes) {
      if (segments.contains(langCode)) {
        return path;
      }
    }

    segments.insert(segments.length - 1, 'unk');
    return segments.join('/');
  }
}

class DuplicateLangSubfolderVisitor implements PathVisitor {
  @override
  String visit(String initialPath) {
    var path = initialPath;
    for (final validLangCode in languageCodesProvider.validLangCodes) {
      final pattern = '/$validLangCode/$validLangCode/';
      if (path.contains(pattern)) {
        path = path.replaceAll(RegExp(pattern), '/$validLangCode/');
      }
    }
    return path;
  }
}

class PrefixCutterPathVisitor implements PathVisitor {
  final String end;
  PrefixCutterPathVisitor({required this.end});

  @override
  String visit(String path) {
    if (path.contains(end)) {
      return path.substring(path.indexOf(end));
    }
    return path;
  }
}
