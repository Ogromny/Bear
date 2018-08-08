import "dart:io";

import "bear_context.dart";
import "bear_route.dart";
import "bear_router.dart";

const version = "0.1.0";

class Bear {
  HttpServer server;
  final BearRouter router = new BearRouter();

  Bear();

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

  /// Start the Bear.
  ///
  /// Takes a [InternetAddress] generally [InternetAddress.loopbackIPv4] and
  /// a port. Takes optional parameters [silent], [silent] allow nothing to
  /// appear.
  void listen(InternetAddress host, int port, {bool silent: false}) async {
    server = await HttpServer.bind(host, port);

    if (!silent) print("🐻️ Listening on ${host.address}:${port}");

    await for (HttpRequest request in server) {
      final context = BearContext(request);

      router.route(context);
    }
  }

  /// Close the Bear.
  ///
  /// Takes optional parameters [force] and [silent], [silent] allow nothing
  /// to appear, [force] force the server to close.
  void close({bool force: false, bool silent: false}) {
    server.close(force: force);

    if (!silent) print("🐻️ Closed");
  }
}
