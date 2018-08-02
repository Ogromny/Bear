import "dart:collection";
import "dart:io" show HttpStatus;

import "charbon_context.dart";
import "charbon_route.dart";

class CharbonRouter {
  final List<CharbonRoute> _routes;

  CharbonRouter() : _routes = new List<CharbonRoute>();

  void add(String method, String path /*, Function handler*/) {
    _routes.add(new CharbonRoute(method, path /*, handler*/));
  }

  void route(CharbonContext charbonContext) {
    final List<CharbonRoute> filteredRoutes = _routes
        .where((CharbonRoute route) =>
            route.method == charbonContext.request.method &&
            route.matches(charbonContext))
        .toList();

    final CharbonRoute topRoute =
        prioritizeRouter(charbonContext, filteredRoutes);

    if (topRoute != null) {
      topRoute.handle(charbonContext);
    } else {
      charbonContext.response.statusCode = HttpStatus.internalServerError;
      charbonContext.response.write("NEED TO IMPLEMENT ERROR HANDLER");
      charbonContext.response.close();
    }
  }

  CharbonRoute prioritizeRouter(
      CharbonContext charbonContext, List<CharbonRoute> routes) {
    final Map<CharbonRoute, int> priorities = new HashMap<CharbonRoute, int>();

    for (CharbonRoute route in routes) {
      final List<String> pathNodes = route.path.split("/");
      final List<String> requestNodes =
          charbonContext.request.uri.path.split("/");

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

    CharbonRoute topRoute;

    for (CharbonRoute route in priorities.keys) {
      if (priorities[route] == values.first) topRoute = route;
    }

    return topRoute;
  }
}
