import 'dart:io';
import 'file_system_interface.dart';
import 'tree_file_system.dart';
import 'virtual_path.dart';

export 'file_system_interface.dart';
export 'tree_file_system.dart';

class VirtualFileSystem implements FileSystem {
  late final Map<String, String> virtualPathToRealPathPair;
  final Map<FileNode, String> fileNodeToVirtualPathPair = {};
  String fileNodeToRealPath(FileNode fileNode) => virtualPathToRealPathPair[fileNodeToVirtualPathPair[fileNode]!]!;

  @override
  late final FileNode root;
  late FileNode _root;

  @override
  File open(FileNode node) => File(fileNodeToRealPath(node));

  VirtualFileSystem({
    required List<String> realPaths,
    required String rootName,
  }) {
    _root = TreeFileNode(rootName);
    root = _buildTreeFileSystem(
      _prepareVirtualPaths(
        realPaths,
        rootName,
      ),
    );
  }

  List<String> _prepareVirtualPaths(List<String> realPaths, String rootNode) {
    virtualPathToRealPathPair = buildVirtualToRealPathPairs(realPaths: realPaths, rootNode: rootNode);
    return virtualPathToRealPathPair.keys.toList();
  }

  FileNode _buildTreeFileSystem(List<String> virtualPaths) {
    try {
      for (final virtualPath in virtualPaths) {
        final parts = virtualPath.split('/').sublist(1);
        var current = _root;
        current = _traverseTree(parts, current);
        final file = TreeFileNode(parts.last);
        fileNodeToVirtualPathPair[file] = virtualPath;
        current.children.add(file);
      }
      return _root;
    } catch (e, t) {
      log.exception(e, t);
      return _root;
    }
  }

  FileNode _traverseTree(List<String> parts, FileNode initial) {
    var current = initial;
    try {
      final len = parts.length - 1;
      for (var i = 0; i < len; i++) {
        final name = parts[i];
        final child = current.findChild(name);
        if (child != null) {
          current = child as TreeFileNode;
        } else {
          current = _addDirectory(current, name);
        }
      }
    } catch (e, t) {
      log.exception(e, t);
    }
    return current;
  }

  FileNode _addDirectory(FileNode current, String name) {
    final directory = TreeFileNode(name);
    current.children.add(directory);
    return directory;
  }
}
