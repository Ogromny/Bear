import "dart:async";

import "bear_context.dart";
import "bear_middleware.dart";

class BearMiddlewares {
  final middlewares = <BearMiddleware>[];

  /// Add a [BearMiddleware] to [middlewares].
  void add(BearMiddleware middleware) => middlewares.add(middleware);

  /// Execute each [BearMiddleware] in [middlewares], then return the
  /// modified ( or not ) [BearContext].
  Future<BearContext> process(BearContext context) async {
    for (var middleware in middlewares) {
      context = await middleware.process(context);
    }

    return Future.value(context);
  }
}
