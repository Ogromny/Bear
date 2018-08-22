import "dart:io";

import "bear_context.dart";
import "bear_middleware.dart";
import "bear_middlewares.dart";
import "bear_route.dart";
import "bear_router.dart";

const version = "0.2.0";

class Bear {
  HttpServer server;
  final router = BearRouter();
  final middlewares = BearMiddlewares();

  /// Add a GET route.
  void get(String path, BearHandler handler) =>
      router.add("GET", path, handler);

  /// Add a POST route.
  void post(String path, BearHandler handler) =>
      router.add("POST", path, handler);

  /// Add a PUT route.
  void put(String path, BearHandler handler) =>
      router.add("PUT", path, handler);

  /// Add a PATCH route.
  void patch(String path, BearHandler handler) =>
      router.add("PATCH", path, handler);

  /// Add a DELETE route.
  void delete(String path, BearHandler handler) =>
      router.add("DELETE", path, handler);

  void static(String path, String directory) => router.static(path, directory);

  /// Start the Bear.
  ///
  /// Takes a [InternetAddress] generally [InternetAddress.loopbackIPv4] and
  /// a port. Takes optional parameters [silent], [silent] allow nothing to
  /// appear.
  void listen(InternetAddress host, int port, {bool silent: false}) async {
    server = await HttpServer.bind(host, port);

    if (!silent) print("ʕ•ᴥ•ʔ Listening on http://${host.address}:${port}");

    await for (HttpRequest request in server) {
      final context = await middlewares.process(BearContext(request));

      router.route(context);
    }
  }

  /// Close the Bear.
  ///
  /// Takes optional parameters [force] and [silent], [silent] allow nothing
  /// to appear, [force] force the server to close.
  void close({bool force: false, bool silent: false}) {
    server.close(force: force);

    if (!silent) print("ʕ•ᴥ•ʔ️ Closed");
  }

  /// Add a middleware.
  void use(BearMiddleware middleware) => middlewares.add(middleware);
}
