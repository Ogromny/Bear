import "dart:io" show HttpStatus;

import "bear_context.dart";
import "bear_route.dart";

class BearRouter {
  final List<BearRoute> routes = <BearRoute>[];

  BearRouter();

  void add(String method, String path, BearHandler handler) {
    for (var route in routes) {
      var score = 0;

      final routeNodes = route.path.split("/").where((e) => e.isNotEmpty).toList();
      final pathNodes = path.split("/").where((e) => e.isNotEmpty).toList();

      if (routeNodes.length != pathNodes.length) break;

      for (var i = 0, j = pathNodes.length; i < j; i++) {
        final routeNode = routeNodes[i];
        final pathNode = pathNodes[i];

        if (routeNode == pathNode ||
            (routeNode.startsWith(":") && pathNode.startsWith(":"))) score += 1;
      }

      if (score == routeNodes.length && route.method == method) return;
    }

    routes.add(BearRoute(method, path, handler));
  }

  void route(BearContext context) {
    final method = context.request.method;
    final path = context.request.uri.path;

    if (path == "/robots.txt" || path == "/favicon.ico") return;

    final matches = routes
        .where((route) => route.method == method && route.matches(context));

    if (matches.isEmpty) {
      context.statusCode = HttpStatus.internalServerError;
      context.send("NEED TO IMPLEMENT ERROR HANDLER");

      return;
    }

    final perfect =
        matches.firstWhere((route) => route.path == path, orElse: () => null);
    if (perfect != null) return perfect.handle(context);

    matches.first.handle(context);
  }
}
