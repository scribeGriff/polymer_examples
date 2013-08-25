import 'dart:html';

class SimpleController {
  final String message = 'World';
}

main() {
  query('#tmpl').model = new SimpleController();
  // See https://github.com/sethladd/dart-polymer-dart-examples/tree/master/web/bind_to_primitive
  // for an even more simplified way to accomplish this.

}