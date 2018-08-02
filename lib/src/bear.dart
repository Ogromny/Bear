import "dart:io";

import "bear_context.dart";
import "bear_router.dart";

class Bear {
  HttpServer _server;
  BearRouter _router;

  Bear(): this._router = new BearRouter();

  void get(String paBth, Function handler) {
    _router.add("GET", path/*, handler*/);
  }

  void post(String path, Function handler) {
    _router.add("POST", path/*, handler*/);
  }

  void listen(InternetAddress host, int port) async {
    this._server = await HttpServer.bind(host, port);

    print("🐻️ Listening on ${host.address}:${port}");

    await for (HttpRequest request in this._server) {
      final BearContext charbonContext = new BearContext(request);
      this._router.route(charbonContext);
    }
  }

  void close() {
    this._server.close();
    print("🐻️ Closed");
  }
}