import "bear_route.dart";
import "../context/bear_context.dart";
import "../utils/bear_utils.dart";
import "../static/bear_static.dart";

const dont_route = ["/robots.txt", "/favicon.ico"];

class BearRouter {
  final routes = <BearRoute>[];
  final statics = <BearStatic>[];

  /// Add a new [BearRoute] to [routes]
  ///
  /// It will check if there is already a similar [BearRoute] in the [routes],
  /// if the [method] and the [path] match a [BearRoute] in [routes], the new
  /// [BearRoute] will not be added.
  void add(String method, String path, Object handler) {
    for (var route in routes) {
      var score = 0;

      final nodes = pathToNodes(path);
      final rodes = pathToNodes(route.path);

      if (rodes.length != nodes.length) continue;

      for (var i = 0, j = nodes.length; i < j; i++) {
        final node = nodes[i];
        final rode = rodes[i];

        if (node == rode || (node.startsWith(":") && rode.startsWith(":"))) {
          score += 1;
        }
      }

      // Exact match, so return for preventing duplication
      if (score == nodes.length && route.method == method) return;
    }

    routes.add(BearRoute(method, path, handler));
  }

  /// Add a new [BearStatic] to [statics]
  ///
  /// It will check if there is already a similar [BearStatic] in the [statics],
  /// if so it will return to prevent from duplication,
  /// otherwise it will add the new [BearStatic].
  void static(String path, String directory) {
    if (path.contains(":")) return;

    for (var _static in statics) {
      var score = 0;

      final nodes = pathToNodes(_static.path);
      final rodes = pathToNodes(path);

      if (nodes.length != rodes.length) continue;

      for (var i = 0, j = nodes.length; i < j; i++) {
        if (nodes[i] == rodes[i]) score += 1;
      }

      // Exact match, so return for preventing duplication
      if (score == nodes.length) return;
    }

    statics.add(BearStatic(path, directory));
  }

  /// Call the correspondent [BearRoute] of the [c]
  ///
  /// It will prioritize the no-variable [BearRoute] first.
  /// Then if no [BearRoute] is found it will search for a variable [BearRoute].
  /// Otherwise it will return an 500.
  void route(BearContext c) {
    final path = c.path;

    if (dont_route.contains(path)) return;

    final static = statics.firstWhere((s) => s.matches(c), orElse: () => null);
    if (static != null) return static.handle(c);

    final list = this.routes.where((r) => r.method == c.method);

    if (list.isNotEmpty) {
      final exact = list.firstWhere((r) => r.path == path, orElse: () => null);
      if (exact != null) return exact.handle(c);

      final dynamic = list.firstWhere((r) => r.matches(c), orElse: () => null);
      if (dynamic != null) return dynamic.handle(c);
    }

    // TODO: implement error
    c.response
      ..statusCode = 500
      ..write("ERROR/TODO")
      ..close();
  }
}
