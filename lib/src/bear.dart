import "dart:io";

import "context/bear_context.dart";
import 'middleware/bear_middleware.dart';
import 'middleware/bear_middlewares.dart';
import "router/bear_router.dart";

class Bear {
  HttpServer server;
  final router = BearRouter();
  final middlewares = BearMiddlewares();

  /// Add a GET route.
  void get(String path, Object handler) => router.add("GET", path, handler);

  /// Add a POST route.
  void post(String path, Object handler) => router.add("POST", path, handler);

  /// Add a PUT route.
  void put(String path, Object handler) => router.add("PUT", path, handler);

  /// Add a PATCH route.
  void patch(String path, Object handler) => router.add("PATCH", path, handler);

  /// Add a DELETE route.
  void delete(String path, Object handler) =>
      router.add("DELETE", path, handler);

  /// Add a static route.
  void static(String path, String directory) => router.static(path, directory);

  /// Add a new [BearMiddleware].
  void use(BearMiddleware middleware) => middlewares.add(middleware);

  /// Start the Bear.
  ///
  /// Takes optional parameters [host] [port] [silent]:
  /// [host] the host to listen.
  /// [port] the port to listen.
  /// [silent] allow nothing to appear.
  void listen(
      {String host = "127.0.0.1", int port = 4040, bool silent: false}) async {
    server = await HttpServer.bind(host, port);

    if (!silent) print("ʕ•ᴥ•ʔ Listening on http://${host}:${port}/.");

    await for (var request in server) {
      router.route(await middlewares.process(BearContext(request)));
    }
  }

  /// Stop the Bear.
  ///
  /// Takes optional parameters [silent] [force]:
  /// [silent] allow nothing to appear.
  /// [force] stop immediately the Bear.
  void close({bool silent: false, bool force: false}) {
    // When no connection have been the server is equals to null...
    server?.close(force: force);

    if (!silent) print("ʕ•ᴥ•ʔ Closed.");
  }
}
