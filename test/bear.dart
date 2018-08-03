import "dart:io" show InternetAddress;

import "package:http/http.dart" as http;
import "package:test/test.dart";

import "../lib/bear.dart";

void main() {
  final String url = "http://${InternetAddress.loopbackIPv4.address}:4040";
  Bear bear;

  setUp(() {
    bear = new Bear();
    bear.get("/test", (BearContext bearContext) {
      bearContext.send("q7XCBj6d6u");
    });
    bear.listen(InternetAddress.loopbackIPv4, 4040, silent: true);
  });

  tearDown(() {
    bear.close(force: true, silent: true);
    bear = null;
  });

  group("🐻 Requests", () {
    test("GET", () {
      http.get("${url}/test").then((http.Response response) {
        expect(response.body, "q7XCBj6d6u");
      });
    });
  });
}
