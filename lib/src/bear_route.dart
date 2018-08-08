import "bear_context.dart";

/// Handler method of each [BearRoute]
typedef BearHandler = void Function(BearContext context);

class BearRoute {
  String method;
  String path;
  final BearHandler handler;

  BearRoute(this.method, this.path, this.handler);

  /// Test if this [BearRoute] correspond to the [context].
  bool matches(BearContext context) {
    final rPath = context.request.uri.path;

    final pathNodes = path.split("/").where((e) => e.isNotEmpty).toList();
    final requestNodes = rPath.split("/").where((e) => e.isNotEmpty).toList();

    if (pathNodes.length != requestNodes.length) return false;
    
    for (var i = 0, j = pathNodes.length; i < j; i++) {
      if (!match(pathNodes[i], requestNodes[i], context)) return false;
    }

    return true;
  }

  /// Test if a node of the this [BearRoute] correspond to a node of the
  /// [context].
  bool match(String pathNode, String requestNode, BearContext context) {
    if (pathNode == requestNode) return true;

    if (pathNode.startsWith(":") && requestNode.isNotEmpty) {
      context.params[pathNode.replaceFirst(":", "")] = requestNode;

      return true;
    }

    return false;
  }

  /// Call this [handler] with the [context].
  void handle(BearContext context) => handler(context);
}
