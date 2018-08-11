import 'dart:async';

import "../lib/bear.dart";

class BearMiddlewareTest implements BearMiddleware {
  @override
  Future<BearContext> process(BearContext context) {
    context.params["2746079324"] = "1863644190";

    return Future.value(context);
  }

}