import "dart:async";

import "bear_context.dart";
import "bear_middleware.dart";

class BearMiddlewares {
  final middlewares = <BearMiddleware>[];

  void add(BearMiddleware middleware) => middlewares.add(middleware);

  Future<BearContext> process(BearContext context) async {
    for (var middleware in middlewares) {
      context = await middleware.process(context);
    }

    return Future.value(context);
  }
}
