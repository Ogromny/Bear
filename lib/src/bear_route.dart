import "bear_context.dart";

typedef BearHandler = void Function(BearContext context);

class BearRoute {
  String method;
  String path;
  final BearHandler handler;

  BearRoute(this.method, this.path, this.handler);

  bool matches(BearContext context) {
    final rPath = context.request.uri.path;

    var pathNodesSplit = path.split("/");
    var requestNodesSplit = rPath.split("/");

    if (pathNodesSplit.length != requestNodesSplit.length) return false;

    final pathNodes = pathNodesSplit.where((e) => e.isNotEmpty).toList();
    final requestNodes = requestNodesSplit.where((e) => e.isNotEmpty).toList();

    for (var i = 0, j = pathNodes.length; i < j; i++) {
      if (!match(pathNodes[i], requestNodes[i], context)) return false;
    }

    return true;
  }

  bool match(String pathNode, String requestNode, BearContext context) {
    if (pathNode == requestNode) return true;

    if (pathNode.startsWith(":") && requestNode.isNotEmpty) {
      context.params[pathNode.replaceFirst(":", "")] = requestNode;

      return true;
    }

    return false;
  }

  void handle(BearContext context) => handler(context);
}
