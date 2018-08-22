import "dart:io";

import "package:bear/bear.dart";

void main() async {
  Bear()
    ..static("/", "")
    ..listen(InternetAddress.loopbackIPv4, 4040);
}
