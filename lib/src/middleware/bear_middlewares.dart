import "dart:async";

import "bear_middleware.dart";
import "../context/bear_context.dart";

/// The "stocker" of middleware.
///
/// It will ensure that each middleware will be executed in order they have been
/// added.
class BearMiddlewares {
  /// The list of middlewares.
  final middlewares = <BearMiddleware>[];

  /// Add a [BearMiddleware] to [middlewares].
  void add(BearMiddleware middleware) => middlewares.add(middleware);

  /// Execute each [BearMiddleware] in [middleware], then return the modified
  /// ( or not ) [BearContext] in a [Future].
  Future<BearContext> process(BearContext c) async {
    for (var middleware in middlewares) {
      c = await middleware.process(c);
    }

    // Automatically transformed to Future<BearContext>
    return c;
  }
}