import "dart:io";

import "context/bear_context.dart";
import 'middleware/bear_middleware.dart';
import 'middleware/bear_middlewares.dart';
import "router/bear_router.dart";

/// The main [Object] you will use.
class Bear {
  /// The intern server of [Bear].
  HttpServer server;

  /// The [BearRouter] which contains routes.
  final router = BearRouter();

  /// The [BearMiddlewares] which contains middlewares.
  final middlewares = BearMiddlewares();

  /// Add a GET route.
  ///
  /// [path] represents the path uri (example: /, /:name, /users/:id/show),
  /// [handler] represents the handler to call when the route is called.
  ///
  /// [handler] can be anything:
  ///
  /// * [String] it will print it in the response of the [BearContext],
  /// * [Function] it will call it and print the return ( if is! null),
  /// * [Function(BearContext)] it will pass it the [BearContext] and call it.
  void get(String path, Object handler) => router.add("GET", path, handler);

  /// Add a POST route.
  ///
  /// [path] represents the path uri (example: /, /:name, /users/:id/show),
  /// [handler] represents the handler to call when the route is called.
  ///
  /// [handler] can be anything:
  ///
  /// * [String] it will print it in the response of the [BearContext],
  /// * [Function] it will call it and print the return ( if is! null),
  /// * [Function(BearContext)] it will pass it the [BearContext] and call it.
  void post(String path, Object handler) => router.add("POST", path, handler);

  /// Add a PUT route.
  ///
  /// [path] represents the path uri (example: /, /:name, /users/:id/show),
  /// [handler] represents the handler to call when the route is called.
  ///
  /// [handler] can be anything:
  ///
  /// * [String] it will print it in the response of the [BearContext],
  /// * [Function] it will call it and print the return ( if is! null),
  /// * [Function(BearContext)] it will pass it the [BearContext] and call it.
  void put(String path, Object handler) => router.add("PUT", path, handler);

  /// Add a PATCH route.
  ///
  /// [path] represents the path uri (example: /, /:name, /users/:id/show),
  /// [handler] represents the handler to call when the route is called.
  ///
  /// [handler] can be anything:
  ///
  /// * [String] it will print it in the response of the [BearContext],
  /// * [Function] it will call it and print the return ( if is! null),
  /// * [Function(BearContext)] it will pass it the [BearContext] and call it.
  void patch(String path, Object handler) => router.add("PATCH", path, handler);

  /// Add a DELETE route.
  ///
  /// [path] represents the path uri (example: /, /:name, /users/:id/show),
  /// [handler] represents the handler to call when the route is called.
  ///
  /// [handler] can be anything:
  ///
  /// * [String] it will print it in the response of the [BearContext],
  /// * [Function] it will call it and print the return ( if is! null),
  /// * [Function(BearContext)] it will pass it the [BearContext] and call it.
  void delete(String path, Object handler) =>
      router.add("DELETE", path, handler);

  /// Add a static route.
  ///
  /// [path] represents the path uri, (example: /statics, /public, /files/images
  /// ), [directory] represents the directory print to in the [BearContext]
  ///
  /// ```dart
  /// Bear()
  ///   ..static("/images", "Documents/Images")
  ///   ..static("/upload", "../Uploads")
  ///   ..listen();
  /// ```
  void static(String path, String directory) => router.static(path, directory);

  /// Add a new [BearMiddleware] to use.
  ///
  /// ```dart
  /// Bear()
  ///   ..use(BearMiddlewareTeapotInjector())
  ///   ..listen();
  /// ```
  void use(BearMiddleware middleware) => middlewares.add(middleware);

  /// Start the [Bear].
  ///
  /// Takes optional parameters [host] [port] [silent]:
  /// * [host] the host to listen.
  /// * [port] the port to listen.
  /// * [silent] output to console nothing.
  void listen(
      {String host = "127.0.0.1", int port = 4040, bool silent: false}) async {
    server = await HttpServer.bind(host, port);

    if (!silent) print("ʕ•ᴥ•ʔ Listening on http://${host}:${port}/.");

    await for (var request in server) {
      router.route(await middlewares.process(BearContext(request)));
    }
  }

  /// Stop the [Bear].
  ///
  /// Takes optional parameters [silent] [force]:
  /// * [silent] output to console nothing.
  /// * [force] stop immediately the Bear.
  void close({bool silent: false, bool force: false}) {
    // When no connection have been the server is equals to null...
    server?.close(force: force);

    if (!silent) print("ʕ•ᴥ•ʔ Closed.");
  }
}
