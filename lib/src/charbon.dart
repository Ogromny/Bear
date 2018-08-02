import "dart:io";

import "charbon_context.dart";
import "charbon_router.dart";

class Charbon {
  HttpServer _server;
  CharbonRouter _router;

  Charbon(): this._router = new CharbonRouter();

  void get(String path, Function handler) {
    _router.addRoute("GET", path, handler);
  }

  void post(String path, Function handler) {
    _router.addRoute("POST", path, handler);
  }

  void listen(InternetAddress host, int port) async {
    this._server = await HttpServer.bind(host, port);

    print("炭 Listening on ${host.address}:${port}");

    await for (HttpRequest request in this._server) {
      CharbonContext charbonContext = new CharbonContext(request);
      this._router.route(charbonContext);
    }
  }

  void close() {
    this._server.close();
    print("炭 Closed");
  }
}