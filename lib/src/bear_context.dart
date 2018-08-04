import "dart:io";

class BearContext {
  HttpRequest get request => _httpRequest;
  HttpRequest _httpRequest;

  HttpResponse get response => _httpResponse;
  HttpResponse _httpResponse;

  BearContext(HttpRequest httpRequest)
      : this._httpRequest = httpRequest,
        this._httpResponse = httpRequest.response;

  void send(String output) {
    this._httpResponse
      ..write(output)
      ..done//.catchError((Error error) => print("🐻️ Error sending response: ""${error}"))
      ..close();
  }
}
