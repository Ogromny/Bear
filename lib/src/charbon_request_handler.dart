import "charbon_context.dart";

class CharbonRequestHandler {
  String get method => _method;
  String _method;

  String get path => _path;
  String _path;

  final Function _handler;

  CharbonRequestHandler(this._method, this._path, this._handler);

  bool matches(CharbonContext charbonContext) {
    if (charbonContext.request.method != _method) return false;

    final List<String> pathSegments = _path.split("/");
    final List<String> requestPathSegments = charbonContext.request.uri.path.split("/");

    final int pathSegmentsLength = pathSegments.length;
    final int requestPathSegmentsLength = requestPathSegments.length;

    if (pathSegmentsLength != requestPathSegmentsLength) return false;

    for (int i = 0; i < pathSegmentsLength; i++) {
      final String pathSegment = pathSegments[i];
      final String requestPathSegment = requestPathSegments[i];

      if (!_match(pathSegment, requestPathSegment)) return false;
    }

    return true;
  }

  bool _match(String pathNode, String requestNode) => pathNode == requestNode;

  void handle(CharbonContext charbonContext) {
    _handler(charbonContext);
  }
}
