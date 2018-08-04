import "dart:io";

import "bear_context.dart";
import "bear_router.dart";

class Bear {
  HttpServer _server;
  BearRouter _router;

  Bear() : this._router = new BearRouter();

  void get(String path, Function handler) {
    _router.add("GET", path, handler);
  }

  void post(String path, Function handler) {
    _router.add("POST", path, handler);
  }
  
  void put(String path, Function handler) {
    _router.add("PUT", path, handler);
  }

  void patch(String path, Function handler) {
    _router.add("PATCH", path, handler);
  }

  void delete(String path, Function handler) {
    _router.add("DELETE", path, handler);
  }

  void listen(InternetAddress host, int port, {bool silent: false}) async {
    this._server = await HttpServer.bind(host, port);

    if (!silent) print("🐻️ Listening on ${host.address}:${port}");

    await for (HttpRequest request in this._server) {
      final BearContext bearContext = new BearContext(request);
      this._router.route(bearContext);
    }
  }

  void close({bool force: false, bool silent: false}) {
    this._server.close(force: force);

    if (!silent) print("🐻️ Closed");
  }
}
