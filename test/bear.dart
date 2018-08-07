import "dart:async";
import "dart:io" show InternetAddress;

import "package:http/http.dart" as http;
import "package:test/test.dart";

import "../lib/bear.dart";

void main() {
  const port = 4040;
  final url = "http://${InternetAddress.loopbackIPv4.address}:${port}";
  Bear bear;

  group("HTTP Methods", () {
    setUp(() {
      bear = new Bear();
      bear.get("/test", (BearContext context) {
        context.send("q7XCBj6d6u");
      });
      bear.post("/test", (BearContext context) {
        context.send("cKuYCuj37o");
      });
      bear.put("/test", (BearContext context) {
        context.send("bQwCbBlZOu");
      });
      bear.patch("/test", (BearContext context) {
        context.send("nK2MwMegkf");
      });
      bear.delete("/test", (BearContext context) {
        context.send("ZkoqQikCHf");
      });

      bear.get("/:name", (BearContext context) {
        context.send("Vadim");
      });
      bear.get("/:name/:age", (BearContext context) {
        context.send("Vadim 20");
      });
      bear.listen(InternetAddress.loopbackIPv4, port, silent: true);
    });

    tearDown(() {
      bear.close(force: true, silent: true);
      bear = null;
    });

    test("GET", () async {
      final get = await http.get("${url}/test");
      expect(get.body, equals("q7XCBj6d6u"));
    });

    test("POST", () async {
      final post = await http.post("${url}/test");
      expect(post.body, equals("cKuYCuj37o"));
    });

    test("PUT", () async {
      final put = await http.put("${url}/test");
      expect(put.body, equals("bQwCbBlZOu"));
    });

    test("PATCH", () async {
      final patch = await http.patch("${url}/test");
      expect(patch.body, equals("nK2MwMegkf"));
    });

    test("DELETE", () async {
      final delete = await http.delete("${url}/test");
      expect(delete.body, equals("ZkoqQikCHf"));
    });

    test("GET Dynamic URL 1", () async {
      final get = await http.get("${url}/Vadim");
      expect(get.body, equals("Vadim"));
    });

    test("GET Dynamic URL 2", () async {
      final get = await http.get("${url}/Vadim/20");
      expect(get.body, equals("Vadim 20"));
    });

    test("GET Dynamic URL 3", () async {
      final get = await http.get("${url}/Vadim//20");
      expect(get.body, isNot(equals("Vadim 20")));
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
