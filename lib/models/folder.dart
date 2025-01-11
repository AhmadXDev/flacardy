class Folder {
  final String fullPath;
  final String name;
  final String? parentPath;

  Folder({required this.fullPath, required this.name, this.parentPath});

  static Folder rowToFolder(Map<String, dynamic> row) {
    return Folder(
      fullPath: row['full_path'],
      name: row['name'],
      parentPath: row['parent_path'],
    );
  }

  Map<String, dynamic> folderToRow() {
    return {
      'full_path': fullPath,
      'name': name,
      'parent_path': parentPath,
    };
  }
}
