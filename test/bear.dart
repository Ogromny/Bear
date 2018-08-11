import "dart:io" show InternetAddress;

import "package:http/http.dart" as http;
import "package:test/test.dart";

import "../lib/bear.dart";
import "bear_middleware_test.dart";

void main() {
  const port = 4040;
  final url = "http://${InternetAddress.loopbackIPv4.address}:${port}";
  Bear bear;

  group("HTTP Methods", () {
    setUp(() {
      bear = Bear();
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
        context.send(context.params["name"]);
      });
      bear.get("/:name/:age", (BearContext context) {
        context.send("${context.params['name']} ${context.params['age']}");
      });
      bear.get("/:name/test/:age", (BearContext context) {
        context.send("${context.params['age']} ${context.params['name']}");
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
      final get = await http.get("${url}////Vadim/////20//");
      expect(get.body, equals("Vadim 20"));
    });

    test("GET Dynamic URL 4", () async {
      final get = await http.get("${url}///Vadim//test/////////20");
      expect(get.body, equals("20 Vadim"));
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

      bear.get("/", (BearContext context) {
        context.send(context.params["2746079324"]);
      });

      bear.use(BearMiddlewareTest());

      bear.listen(InternetAddress.loopbackIPv4, 4040, silent: true);
    });

    tearDown(() {
      bear.close(silent: true);
      bear = null;
    });

    test("Simple", () async {
      final middleware = await http.get("${url}/");
      expect(middleware.body, equals("1863644190"));
    });
  });
}
