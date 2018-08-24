import "../context/bear_context.dart";
import "../utils/bear_utils.dart";

class BearRoute {
  String method;
  String path;
  dynamic handler;

  BearRoute(this.method, this.path, this.handler);

  /// Test if this [BearRoute] fully match the [c]
  bool matches(BearContext c) {
    final nodes = pathToNodes(path);
    final rodes = pathToNodes(c.request.uri.path);

    if (nodes.length != rodes.length) return false;

    for (var i = 0, j = nodes.length; i < j; i++) {
      final node = nodes[i];
      final rode = rodes[i];

      // Exact match
      if (node == rode) continue;

      // Dynamic match
      if (node.startsWith(":") && rode.isNotEmpty) {
        c.params[node.replaceFirst(":", "")] = rode;

        continue;
      }

      return false;
    }

    return true;
  }

  /// Call the [handler]
  ///
  /// If [handler] is a [Function] who take a [BearContext], call it with [c]
  /// Else if [handler] is a [Function], call it and if the return isn't null, write the return to the response
  /// Otherwise write the [handler] to the response.
  void handle(BearContext c) {
    if (handler is Function(BearContext)) {
      handler(c);
    } else if (handler is Function) {
      c.response
        ..write(handler())
        ..close();
    } else {
      c.response
        ..write(handler)
        ..close();
    }
  }
}