import "bear_context.dart";

typedef BearHandler = void Function(BearContext context);

class BearRoute {
  String method;
  String path;
  final BearHandler handler;

  BearRoute(this.method, this.path, this.handler);

  bool matches(BearContext context) {
    final rPath = context.request.uri.path;

    final pathNodes = path.split("/").where((e) => e.isNotEmpty).toList();
    final requestNodes = rPath.split("/").where((e) => e.isNotEmpty).toList();

    if (pathNodes.length != requestNodes.length) return false;

    for (var i = 0, j = pathNodes.length; i < j; i++) {
      if (!match(pathNodes[i], requestNodes[i])) return false;
    }

    return true;
  }

  bool match(String pathNode, String requestNode) => pathNode == requestNode;

  void handle(BearContext context) => handler(context);
}
