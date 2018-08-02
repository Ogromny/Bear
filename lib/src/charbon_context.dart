import "dart:io";

class CharbonContext {
  HttpRequest get request => _httpRequest;
  HttpRequest _httpRequest;

  HttpResponse get response => _httpResponse;
  HttpResponse _httpResponse;

  CharbonContext(HttpRequest httpRequest)
      : this._httpRequest = httpRequest,
        this._httpResponse = httpRequest.response;

  void send(String output) {
    this._httpResponse
      ..write(output)
      ..done.catchError((Error e) => print("炭 Error sending response: ${e}"))
      ..close();
  }
}
