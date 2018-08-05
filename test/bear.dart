import "dart:async";
import "dart:io" show InternetAddress;

import "package:http/http.dart" as http;
import "package:test/test.dart";

import "../lib/bear.dart";

void main() {
  const int port = 4040;
  final String url = "http://${InternetAddress.loopbackIPv4.address}:${port}";
  Bear bear;

  group("HTTP Methods", () {
    setUp(() {
      bear = new Bear();
      bear.get("/test", (BearContext bearContext) {
        bearContext.send("q7XCBj6d6u");
      });
      bear.post("/test", (BearContext bearContext) {
        bearContext.send("cKuYCuj37o");
      });
      bear.put("/test", (BearContext bearContext) {
        bearContext.send("bQwCbBlZOu");
      });
      bear.patch("/test", (BearContext bearContext) {
        bearContext.send("nK2MwMegkf");
      });
      bear.delete("/test", (BearContext bearContext) {
        bearContext.send("ZkoqQikCHf");
      });
      bear.listen(InternetAddress.loopbackIPv4, port, silent: true);
    });

    tearDown(() {
      bear.close(force: true, silent: true);
      bear = null;
    });

    test("GET", () async {
      http.Response get = await http.get("${url}/test");
      expect(get.body, equals("q7XCBj6d6u"));
    });

    test("POST", () async {
      http.Response post = await http.post("${url}/test");
      expect(post.body, equals("cKuYCuj37o"));
    });

    test("PUT", () async {
      http.Response put = await http.put("${url}/test");
      expect(put.body, equals("bQwCbBlZOu"));
    });

    test("PATCH", () async {
      http.Response patch = await http.patch("${url}/test");
      expect(patch.body, equals("nK2MwMegkf"));
    });

    test("DELETE", () async {
      http.Response delete = await http.delete("${url}/test");
      expect(delete.body, equals("ZkoqQikCHf"));
    });
  });

  group("Router", () {
    test("Anti-duplication", () {
      bear = new Bear();

      bear.get("/test", null);
      bear.get("/test", null);
      bear.get("/test", null);

      expect(bear.router.routes.length, equals(1));
    });
  });
}
