import "charbon_context.dart";

class CharbonRoute {
  String get method => _method;
  String _method;

  String get path => _path;
  String _path;

//  final Function _handler;

  CharbonRoute(this._method, this._path /*, this._handler*/);

  bool matches(CharbonContext charbonContext) {
    if (charbonContext.request.method != _method) return false;

    final List<String> pathNodes = _path.split("/");
    final List<String> requestNodes =
        charbonContext.request.uri.path.split("/");

    if (pathNodes.length != requestNodes.length) return false;

    for (int i = 0; i < pathNodes.length; i++) {
      final String pathNode = pathNodes[i];
      final String requestNode = requestNodes[i];

      if (!_match(pathNode, requestNode)) return false;
    }

    return true;
  }

  bool _match(String pathNode, String requestNode) => pathNode == requestNode;

  void handle(CharbonContext charbonContext) {
    // TODO
//    _handler(charbonContext);
  }
}
