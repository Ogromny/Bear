import "dart:io";

import "bear_context.dart";
import "bear_route.dart";
import "bear_router.dart";

class Bear {
  HttpServer server;
  final BearRouter router = new BearRouter();

  Bear();

  void get(String path, BearHandler handler) =>
      router.add("GET", path, handler);

  void post(String path, BearHandler handler) =>
      router.add("POST", path, handler);

  void put(String path, BearHandler handler) =>
      router.add("PUT", path, handler);

  void patch(String path, BearHandler handler) =>
      router.add("PATCH", path, handler);

  void delete(String path, BearHandler handler) =>
      router.add("DELETE", path, handler);

  void listen(InternetAddress host, int port, {bool silent: false}) async {
    server = await HttpServer.bind(host, port);

    if (!silent) print("🐻️ Listening on ${host.address}:${port}");

    await for (HttpRequest request in server) {
      final context = new BearContext(request);

      router.route(context);
    }
  }

  void close({bool force: false, bool silent: false}) {
    server.close(force: force);

    if (!silent) print("🐻️ Closed");
  }
}
