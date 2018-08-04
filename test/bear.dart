import "dart:async";
import "dart:io" show InternetAddress;

import "package:http/http.dart" as http;
import "package:test/test.dart";

import "../lib/bear.dart";

void main() {
  const int port = 4040;
  final String url = "http://${InternetAddress.loopbackIPv4.address}:${port}";
  Bear bear;

  setUp(() {
    bear = new Bear();
    bear.get("/test", (BearContext bearContext) {
      bearContext.send("q7XCBj6d6u");
    });
    bear.post("/test", (BearContext bearContext) {
      bearContext.send("cKuYCuj37o");
    });
    bear.listen(InternetAddress.loopbackIPv4, port, silent: true);
  });

  tearDown(() {
    bear.close(force: true, silent: true);
    bear = null;
  });

  group("HTTP Methods", () {
    test("GET", () async {
      http.Response get = await http.get("${url}/test");
      expect(get.body, equals("q7XCBj6d6u"));
    });

    test("POST", () async {
      http.Response post = await http.post("${url}/test");
      expect(post.body, equals("cKuYCuj37o"));
    });
  });
}
