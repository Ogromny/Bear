import "dart:io";

import "context/bear_context.dart";
import "router/bear_router.dart";

class Bear {
  HttpServer _server;
  final router = BearRouter();

  /// Add a GET route.
  void get(String path, Function(BearContext) handler) =>
      router.add("GET", path, handler);

  /// Add a POST route.
  void post(String path, Function(BearContext) handler) =>
      router.add("POST", path, handler);

  /// Add a PUT route.
  void put(String path, Function(BearContext) handler) =>
      router.add("PUT", path, handler);

  /// Add a PATCH route.
  void patch(String path, Function(BearContext) handler) =>
      router.add("PATCH", path, handler);

  /// Add a DELETE route.
  void delete(String path, Function(BearContext) handler) =>
      router.add("DELETE", path, handler);

  void listen({String host = "127.0.0.1", int port = 4040, bool silent: false}) async {
    _server = await HttpServer.bind(host, port);

    if (!silent) print("ʕ•ᴥ•ʔ Listening on http://${host}:${port}/.");

    await for (var request in _server) {
      //TODO: middleware
      router.route(BearContext(request));
    }
  }

  void close({bool silent: false, bool force: false}) {
    _server.close(force: force);

    if (!silent) print("ʕ•ᴥ•ʔ Closed.");
  }
}