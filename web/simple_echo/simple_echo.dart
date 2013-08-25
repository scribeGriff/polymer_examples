import 'dart:html';
import 'package:polymer/polymer.dart';

class SimpleEcho extends Object with ObservableMixin {
  @observable
  String name;
}

main() {
  query('#tmpl').model = new SimpleEcho();
}