import "dart:io";

class BearContext {
  HttpRequest request;
  HttpResponse response;

  BearContext(this.request) : response = request.response;

  void send(String output) => response
    ..write(output)
    ..done
    ..close();
}
