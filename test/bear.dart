import "dart:io" show InternetAddress;

import "package:http/http.dart" as http;
import "package:test/test.dart";

import "bear_middleware_test.dart";
import "../lib/bear.dart";

void main() {
  const port = 4040;
  final url = "http://${InternetAddress.loopbackIPv4.address}:${port}";
  Bear bear;

  group("HTTP Methods", () {
    setUp(() {
      bear = Bear();
      bear.get("/test", (BearContext context) {
        context.response
          ..write("q7XCBj6d6u")
          ..close();
      });
      bear.post("/test", (BearContext context) {
        context.response
          ..write("cKuYCuj37o")
          ..close();
      });
      bear.put("/test", (BearContext context) {
        context.response
          ..write("bQwCbBlZOu")
          ..close();
      });
      bear.patch("/test", (BearContext context) {
        context.response
          ..write("nK2MwMegkf")
          ..close();
      });
      bear.delete("/test", (BearContext context) {
        context.response
          ..write("ZkoqQikCHf")
          ..close();
      });

      bear.get("/:name", (BearContext context) {
        context.response
          ..write(context.params["name"])
          ..close();
      });
      bear.get("/:name/:age", (BearContext context) {
        context.response
          ..write("${context.params['name']} ${context.params['age']}")
          ..close();
      });
      bear.get("/:name/test/:age", (BearContext context) {
        context.response
          ..write("${context.params['age']} ${context.params['name']}")
          ..close();
      });
      bear.get("/dyn1", "dyndyndyn");
      bear.get("/dyn2", () => "dyndyndyn");
      bear.listen(silent: true);
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
      final get = await http.get("${url}////Vadim/////20//");
      expect(get.body, equals("Vadim 20"));
    });

    test("GET Dynamic URL 4", () async {
      final get = await http.get("${url}/Vadim//test/////////20");
      expect(get.body, equals("20 Vadim"));
    });

    test("Dynamic Handler 1", () async {
      final dyn = await http.get("${url}/dyn1");
      expect(dyn.body, equals("dyndyndyn"));
    });

    test("Dynamic Handler 2", () async {
      final dyn = await http.get("${url}/dyn2");
      expect(dyn.body, equals("dyndyndyn"));
    });
  });

  group("Router", () {
    test("Anti-duplication", () {
      bear = Bear();

      bear.get("/test", null);
      bear.get("/test", null);
      bear.get("/test", null);

      expect(bear.router.routes.length, equals(1));
    });
  });

  group("Middleware", () {
    setUp(() {
      bear = Bear();

      bear.get("/", (BearContext c) {
        c.response
          ..write(c.params["2746079324"])
          ..close();
      });

      bear.use(BearMiddlewareTest());

      bear.listen(silent: true);
    });

    tearDown(() {
      bear.close(force: true, silent: true);
      bear = null;
    });

    test("Simple", () async {
      final middleware = await http.get("${url}/");
      expect(middleware.body, equals("1863644190"));
    });
  });

  group("Static", () {
    setUp(() {
      bear = Bear();

      bear.static("/", "");
      bear.static("/t/e/s/t", "");
      bear.static("/t/e/s/t/", "");

      bear.listen(silent: true);
    });

    tearDown(() {
      bear.close(force: true, silent: true);
      bear = null;
    });

    test("Simple", () async {
      final static = await http.get("${url}/test/static");
      expect(static.body, equals("This is a test"));
    });

    test("Anti duplication", () async {
      expect(bear.router.statics.length, equals(2));
    });
  });
}
