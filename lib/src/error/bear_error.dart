import "dart:io";

import "../context/bear_context.dart";

void errorHandler(BearContext c) {
  final buffer = StringBuffer();

  buffer
    ..write("<!DOCTYPE html>")
    ..write("<html>")
    ..write("<head>")
    ..write("<title>Bear</title>")
    ..write("</head>")
    ..write("<style>")
    ..write("body {")
    ..write("height: 100vh;")
    ..write("max-width: 100vw;")
    ..write("width: 100%;")
    ..write("display: flex;")
    ..write("align-items: center;")
    ..write("justify-content: center;")
    ..write("background-color: #d8dee9;")
    ..write("}")
    ..write("h1 {")
    ..write("color: #2e3440;")
    ..write("font-size: 3rem;")
    ..write("}")
    ..write("</style>")
    ..write("<body>")
    ..write("<h1><span style='color: #bf616a'>[BEAR]:</span> 500</h1>")
    ..write("</body>")
    ..write("</html>");

  c.response
    ..statusCode = 500
    ..headers.set(HttpHeaders.contentTypeHeader, ContentType.html.mimeType)
    ..write(buffer.toString())
    ..close();
}
