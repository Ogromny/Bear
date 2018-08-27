import "dart:async";

import "../context/bear_context.dart";

/// The base of all middleware.
///
/// ```dart
/// class BearMiddlewareTeapot implements BearMiddleware {
///  @override
///  Future<BearContext> process(BearContext c) {
///    c.response
///      ..statusCode = 418
///      ..write("I'm a Teapot !");
///
///    return Future.value(c);
///  }
///}
/// ```
abstract class BearMiddleware {
  /// The main function of each middleware.
  ///
  /// Take a [BearContext], modify it ( or not, as you want ) and return it in
  /// Future[BearContext].
  Future<BearContext> process(BearContext c);
}