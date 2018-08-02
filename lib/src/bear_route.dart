import "bear_context.dart";

class BearRoute {
  String get method => _method;
  String _method;

  String get path => _path;
  String _path;

//  final Function _handler;

  BearRoute(this._method, this._path /*, this._handler*/);

  bool matches(BearContext charbonContext) {
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

  void handle(BearContext charbonContext) {
    // TODO
//    _handler(charbonContext);
  }
}
