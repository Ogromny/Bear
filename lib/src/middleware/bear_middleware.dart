import "dart:async";

import "../context/bear_context.dart";

/// All Middleware need to _implements_ [BearMiddleware].
abstract class BearMiddleware {
  Future<BearContext> process(BearContext c);
}