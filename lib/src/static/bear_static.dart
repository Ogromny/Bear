import "dart:io";

import "package:path/path.dart" as p;
import "package:mime/mime.dart";

import "../context/bear_context.dart";
import "../error/bear_error.dart";
import "../utils/bear_utils.dart";

/// Object of each static.
class BearStatic {
  /// The uri to match, (example: /statics, /files, /uploads/images, ...).
  String path;

  /// The directory to render, ( relative path, or absolute ) ( example: ../files )
  String directory;

  /// Constructor.
  ///
  /// Take the [path] and the [directory].
  ///
  /// If the [directory] provided doesn't exist throw an error.
  BearStatic(this.path, String dir) : directory = p.normalize(p.absolute(dir)) {
    if (!Directory(directory).existsSync()) {
      throw "[BearStatic]: ${directory} directory doesn't exist.";
    }
  }

  /// Check if [path] correspond to the [BearContext].
  bool matches(BearContext c) {
    final nodes = pathToNodes(path);
    final rodes = pathToNodes(c.request.uri.path);

    if (nodes.length > rodes.length) return false;

    for (var i = 0, j = nodes.length; i < j; i++) {
      if (nodes[i] != rodes[i]) return false;
    }

    return true;
  }

  /// Send the [file] to the [BearContext].
  void serveFile(File file, BearContext c) {
    final buffer = <int>[];
    buffer.length = file.lengthSync();
    file.openSync().readIntoSync(buffer);

    final contentType = lookupMimeType(file.path) ?? ContentType.text.mimeType;
    c.response
      ..headers.set(HttpHeaders.contentTypeHeader, contentType)
      ..add(buffer)
      ..close();
  }

  /// List the content of the [directory].
  void serveDirectory(Directory directory, BearContext c) {
    final uri = c.request.uri;
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

    // First line ( .. )
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

    // Struct of directory
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

    c.response
      ..headers.set(HttpHeaders.contentTypeHeader, ContentType.html.mimeType)
      ..write(buffer.toString())
      ..close();
  }

  /// Determine which function need to be called.
  void handle(BearContext c) {
    final remotePath = c.request.uri.path;
    final path = remotePath.contains("..")
        ? directory
        : p.joinAll(p.split(directory) +
            remotePath.replaceFirst(this.path, "").split("/"));

    switch (FileSystemEntity.typeSync(path)) {
      case FileSystemEntityType.file:
        serveFile(File(path), c);
        break;
      case FileSystemEntityType.directory:
        serveDirectory(Directory(path), c);
        break;
      default:
        errorHandler(c);
    }
  }
}
