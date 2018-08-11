import "dart:async";

import "bear_context.dart";

abstract class BearMiddleware {
  Future<BearContext> process(BearContext context);
}
