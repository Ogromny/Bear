import "dart:io";

class BearContext {
  HttpRequest request;
  HttpResponse response;
  Map<String, String> params;

  int get statusCode => response.statusCode;
  set statusCode(int code) => response.statusCode = code;

  BearContext(this.request)
      : response = request.response,
        params = Map.from(request.uri.queryParameters);

  /// Write and immediately close the context.
  void send(String output) => response
    ..write(output)
    ..close();
}
