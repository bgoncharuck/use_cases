import 'file_system_interface.dart';
import 'tree_file_system.dart';
import 'virtual_path.dart';

FileSystem createVirtualFileSystem(List<String> realPaths, String rootNode) {
  try {
    final virtualPaths = prepareVirtualPaths(realPaths, rootNode);
    final root = _buildTreeFileSystem(virtualPaths, rootNode);
    return TreeFileSystem(root);
  } catch (e, t) {
    log.exception(e, t);
    return TreeFileSystem(TreeFileNode(rootNode));
  }
}

TreeFileNode _buildTreeFileSystem(List<String> virtualPaths, String rootNode) {
  try {
    fileNodeToVirtualPathPair.clear();

    final root = TreeFileNode(rootNode);
    for (final virtualPath in virtualPaths) {
      final parts = virtualPath.split('/').sublist(1);
      var current = root;
      current = _traverseTree(parts, current);
      final file = TreeFileNode(parts.last);
      fileNodeToVirtualPathPair[file] = virtualPath;
      current.children.add(file);
    }
    return root;
  } catch (e, t) {
    log.exception(e, t);
    return TreeFileNode(rootNode);
  }
}

TreeFileNode _traverseTree(List<String> parts, TreeFileNode initial) {
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

TreeFileNode _addDirectory(TreeFileNode current, String name) {
  final directory = TreeFileNode(name);
  current.children.add(directory);
  return directory;
}
