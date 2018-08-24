import "../context/bear_context.dart";
import "../utils/bear_utils.dart";

class BearRoute {
  String method;
  String path;
  Function(BearContext context) handler;

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

  /// Call this [handler] with the [c]
  void handle(BearContext c) => handler(c);
}