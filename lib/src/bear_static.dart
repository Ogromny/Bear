import "dart:convert";
import "dart:io";

import "package:path/path.dart" as p;
import "package:mime/mime.dart";

import "bear_context.dart";

class BearStatic {
  String path;
  String directory;

  BearStatic(this.path, String dir) : directory = p.normalize(p.absolute(dir)) {
    if (!Directory(directory).existsSync()) {
      throw "${directory} directory doesn't exist.";
    }
  }

  bool matches(BearContext context) {
    final rPath = context.request.uri.path;

    final pathNodes = path.split("/").where((e) => e.isNotEmpty).toList();
    final requestNodes = rPath.split("/").where((e) => e.isNotEmpty).toList();

    if (requestNodes.length < pathNodes.length) return false;

    for (var i = 0, j = pathNodes.length; i < j; i++) {
      if (pathNodes[i] != requestNodes[i]) return false;
    }

    return true;
  }

  String resolvePath(String rPath) =>
      p.joinAll(p.split(directory) + rPath.replaceFirst(path, "").split("/"));

  void serveFile(File file, BearContext context) {
    final buffer = <int>[];
    buffer.length = file.lengthSync();
    file.openSync().readIntoSync(buffer);

    context.mimeType = lookupMimeType(file.path) ?? ContentType.text.mimeType;
    context.response
      ..add(buffer)
      ..close();
  }

  void serveDirectory(Directory directory, BearContext context) {
    final uri = context.request.uri;
    final buffer = StringBuffer();

    buffer
      ..write("<!DOCTYPE html>")
      ..write("<html>")
      ..write("<head>")
      ..write("<title>${uri}</title>")
      ..write("</head>")
      ..write("<body>")
      ..write("<h1>Index of ${uri.path.replaceFirst(path, "")}</h1>")
      ..write("<pre>")
      ..write("Name${" " * (50 - "Name".length)}")
      ..write("Last modified${" " * (30 - "Last modified".length)}")
      ..write("Size")
      ..write("</pre>")
      ..write('<hr noshade align="left" width="80%">')
      ..write("<pre>");

    if ("${path}/" != uri.path && path != uri.path) {
      final parent = directory.parent;
      final parentPath = p.relative(parent.path, from: this.directory);
      final parentModified = parent.statSync().modified.toString();
      final parentSize = parent.statSync().size;

      buffer
        ..write("<a href='${p.join(path, parentPath)}'>..</a>")
        ..write("${" " * (50 - "..".length)}")
        ..write("${parentModified}${" " * (30 - parentModified.length)}")
        ..write("${parentSize}")
        ..write("<br>");
    }


    for (var file in directory.listSync()) {
      final name = p.basename(file.path);
      final modified = file.statSync().modified.toString();
      final size = file.statSync().size;

      buffer
        ..write("<a href='${p.join(uri.path, name)}'>${name}</a>")
        ..write("${" " * (50 - name.length)}")
        ..write("${modified}${" " * (30 - modified.length)}")
        ..write("${size}")
        ..write("<br>");
    }

    buffer
      ..write('<hr noshade align="left" width="80%">')
      ..write("</pre>")
      ..write("</body>")
      ..write("</html>");

    context.mimeType = ContentType.html.mimeType;
    context.send(buffer.toString());
  }

  void handle(BearContext context) {
    final rPath = context.request.uri.path;

    final path = rPath.contains("..") ? directory : resolvePath(rPath);

    switch (FileSystemEntity.typeSync(path)) {
      case FileSystemEntityType.file:
        serveFile(File(path), context);
        break;
      case FileSystemEntityType.directory:
        serveDirectory(Directory(path), context);
        break;
      default:
        context.statusCode = HttpStatus.internalServerError;
        context.send("NEED TO IMPLEMENT ERROR HANDLER");
    }
  }
}
