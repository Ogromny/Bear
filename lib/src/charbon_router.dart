import "dart:collection";
import "dart:io" show HttpStatus;

import "charbon_context.dart";
import "charbon_request_handler.dart";

class CharbonRouter {
  List<CharbonRequestHandler> _routes;

  CharbonRouter() : _routes = new List<CharbonRequestHandler>();

  void addRoute(String method, String path, Function handler) {
    _routes.add(new CharbonRequestHandler(method, path, handler));
  }

  void route(CharbonContext charbonContext) {
    List<CharbonRequestHandler> filteredRoutes = _routes
        .where((CharbonRequestHandler route) =>
    route.method == charbonContext.request.method &&
        route.matches(charbonContext))
        .toList();

    CharbonRequestHandler finalRoute = prioritizeRouter(charbonContext, filteredRoutes);

    if (finalRoute != null) {
      finalRoute.handle(charbonContext);
    } else {
      charbonContext.response.statusCode = HttpStatus.internalServerError;
      charbonContext.response.close();
    }
  }

  CharbonRequestHandler prioritizeRouter(CharbonContext charbonContext,
      List<CharbonRequestHandler> routes) {
    Map<CharbonRequestHandler, int> mapPriorities = new HashMap<
        CharbonRequestHandler,
        int>();

    for (CharbonRequestHandler handler in routes) {
      List<String> pathSegments = handler.path.split("/");
      List<String> reqPathSegments = charbonContext.request.uri.path.split("/");

      for (int i = 0; i < pathSegments.length; i++) {
        String pathSegment = pathSegments[i];
        String reqPathSegment = reqPathSegments[i];

        mapPriorities.putIfAbsent(handler, () => 0);

        if (pathSegment == reqPathSegment) {
          mapPriorities[handler] += 2;
        } else if (pathSegment.startsWith(":")) {
          mapPriorities[handler] += 1;
        }
      }
    }

    List<int> values = mapPriorities.values.toList();
    values.sort((int a, int b) => b - a);

    for (CharbonRequestHandler handler in mapPriorities.keys) {
      if (mapPriorities[handler] == values[0]) return handler;
    }
  }
}
