import "dart:io";

/// The Context of each request.
class BearContext {
  /// The [HttpRequest].
  HttpRequest request;

  /// The [HttpResponse] ( for writing response, content-type, etc ).
  HttpResponse response;

  /// The Map of dynamic variable ( /:name, params["name"] ).
  Map<String, String> params;

  /// Shortcut for getting the request method.
  String get method => request.method;

  /// Shortcut for getting the request path.
  String get path => request.uri.path;

  /// Constructor take an [HttpRequest].
  BearContext(this.request)
      : response = request.response,
        params = Map.from(request.uri.queryParameters);
}