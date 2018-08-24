import "dart:io";

class BearContext {
  HttpRequest request;
  HttpResponse response;
  Map<String, String> params;

  String get method => request.method;
  String get path => request.uri.path;

  BearContext(this.request)
      : response = request.response,
        params = Map.from(request.uri.queryParameters);
}