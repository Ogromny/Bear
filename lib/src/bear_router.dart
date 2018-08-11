import "dart:io" show HttpStatus;

import "bear_context.dart";
import "bear_route.dart";

class BearRouter {
  final routes = <BearRoute>[];

  /// Add a new [BearRoute] to [routes].
  ///
  /// It will check if there is already a similar [BearRoute] in the
  /// [routes], if yes then it will end the function.
  void add(String method, String path, BearHandler handler) {
    for (var route in routes) {
      var score = 0;

      final routeNodes =
          route.path.split("/").where((e) => e.isNotEmpty).toList();
      final pathNodes = path.split("/").where((e) => e.isNotEmpty).toList();

      if (routeNodes.length != pathNodes.length) continue;

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

  /// Call the correspond [BearRoute] of the [context]
  ///
  /// It will prioritize the no-variable [BearRoute] first.
  /// If there is no no-variable [BearRoute] it will call the correspond
  /// variable [BearRoute]. Otherwise it will return an 500 error.
  void route(BearContext context) {
    final method = context.request.method;
    final path = context.request.uri.path;

    if (path == "/robots.txt" || path == "/favicon.ico") return;

    final matches = routes.where((route) => route.method == method);

    if (matches.isNotEmpty) {
      final perfect =
          matches.firstWhere((r) => r.path == path, orElse: () => null);
      if (perfect != null) return perfect.handle(context);

      final match =
          matches.firstWhere((r) => r.matches(context), orElse: () => null);
      if (match != null) return match.handle(context);
    }

    context.statusCode = HttpStatus.internalServerError;
    context.send("NEED TO IMPLEMENT ERROR HANDLER");
  }
}
