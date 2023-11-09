// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'file_system_interface.dart';

class TreeFileNode implements FileNode {
  @override
  final String name;
  @override
  final List<FileNode> children = [];

  TreeFileNode(this.name);

  @override
  bool get isFile => children.isEmpty;

  @override
  bool get isDirectory => children.isNotEmpty;

  @override
  FileNode? findChild(String name) {
    try {
      return children.firstWhere((child) => child.name == name);
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileNode && runtimeType == other.runtimeType && name == other.name && children == other.children;

  @override
  int get hashCode => name.hashCode ^ children.hashCode;
}

class TreeFileSystem implements FileSystem {
  @override
  final FileNode root;

  TreeFileSystem(this.root);
}
