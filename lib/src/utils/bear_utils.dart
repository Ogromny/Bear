/// Take a [path] and return it in a [List] of node ([String]).
List<String> pathToNodes(String path) =>
    path.split("/").where((e) => e.isNotEmpty).toList();
