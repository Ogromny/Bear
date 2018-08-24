List<String> pathToNodes(String path) =>
    path.split("/").where((e) => e.isNotEmpty).toList();
