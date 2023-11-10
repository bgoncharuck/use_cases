// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'dart:io';

abstract class FileNode {
  String get name;

  List<FileNode> get children;

  bool get isFile;

  bool get isDirectory;

  FileNode? findChild(String name);

  List<FileNode> get files;

  List<FileNode> get directories;

  FileNode? get parent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileNode && runtimeType == other.runtimeType && name == other.name && children == other.children;

  @override
  int get hashCode => name.hashCode ^ children.hashCode;
}

abstract class FileSystem {
  FileNode get root;
  File open(FileNode node);
}
