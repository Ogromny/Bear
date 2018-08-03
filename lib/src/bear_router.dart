import "dart:collection";
import "dart:io" show HttpStatus;

import "bear_context.dart";
import "bear_route.dart";

class BearRouter {
  final List<BearRoute> _routes;

  BearRouter() : _routes = new List<BearRoute>();

  void add(String method, String path, Function handler) {
    _routes.add(new BearRoute(method, path, handler));
  }

  void route(BearContext bearContext) {
    final List<BearRoute> filteredRoutes = _routes
        .where((BearRoute route) =>
            route.method == bearContext.request.method &&
            route.matches(bearContext))
        .toList();

    final BearRoute topRoute = prioritizeRouter(bearContext, filteredRoutes);

    if (topRoute != null) {
      topRoute.handle(bearContext);
    } else {
      bearContext.response.statusCode = HttpStatus.internalServerError;
      bearContext.response.write("NEED TO IMPLEMENT ERROR HANDLER");
      bearContext.response.close();
    }
  }

  BearRoute prioritizeRouter(
      BearContext bearContext, List<BearRoute> routes) {
    final Map<BearRoute, int> priorities = new HashMap<BearRoute, int>();

    for (BearRoute route in routes) {
      final List<String> pathNodes = route.path.split("/");
      final List<String> requestNodes =
          bearContext.request.uri.path.split("/");

      for (int i = 0; i < pathNodes.length; i++) {
        final String pathNode = pathNodes[i];
        final String requestNode = requestNodes[i];

        priorities.putIfAbsent(route, () => 0);

        if (pathNode == requestNode) {
          priorities[route] += 2;
        } else if (pathNode.startsWith(":")) {
          priorities[route] += 1;
        }
      }
    }

    final List<int> values = priorities.values.toList();
    values.sort((int a, int b) => b - a);

    BearRoute topRoute;

    for (BearRoute route in priorities.keys) {
      if (priorities[route] == values.first) topRoute = route;
    }

    return topRoute;
  }
}
