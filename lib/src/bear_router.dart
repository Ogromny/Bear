import "dart:io" show HttpStatus;

import "bear_context.dart";
import "bear_route.dart";

class BearRouter {
  final List<BearRoute> routes = <BearRoute>[];

  BearRouter();

  void add(String method, String path, BearHandler handler) {
    for (var route in routes) {
      if (route.path == path && route.method == method) return;
    }

    routes.add(BearRoute(method, path, handler));
  }

  void route(BearContext context) {
    final method = context.request.method;

    final routes = this
        .routes
        .where((route) => route.method == method && route.matches(context))
        .toList();

    if (routes.isEmpty) {
      // TODO
      context.response.statusCode = HttpStatus.internalServerError;
      context.send("NEED TO IMPLEMENT ERROR HANDLER");
    }

    final priorities = Map<BearRoute, int>();

    for (var route in routes) {
      priorities.putIfAbsent(route, () => 0);

      final path = route.path;
      final rPath = context.request.uri.path;

      final pathNodes = path.split("/").where((e) => e.isNotEmpty).toList();
      final requestNodes = rPath.split("/").where((e) => e.isNotEmpty).toList();

      for (int i = 0, j = pathNodes.length; i < j; i++) {
        final pathNode = pathNodes[i];
        final requestNode = requestNodes[i];

        priorities[route] += pathNode.startsWith(":") ? 2 : 1;
      }

      final sorted = priorities.values.toList();
      sorted.sort((int a, int b) => b - a);

      for (var route in priorities.keys) {
        if (priorities[route] == sorted.first) {
          return route.handle(context);
        }
      }

      context.response
        ..statusCode = HttpStatus.internalServerError
        ..write("NEED TO IMPLEMENT ERROR HANDLER")
        ..close();
    }
  }
}
