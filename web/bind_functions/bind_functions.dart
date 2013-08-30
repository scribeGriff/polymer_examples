import 'dart:html';
import 'package:polymer/polymer.dart';

class Person extends Object with ObservableMixin{
  @observable String name;

  Person([this.name = '']);
}

@CustomTag('greetings-element')
class Greetings extends PolymerElement with ObservableMixin {
  @observable String message;
  @observable Person person = new Person();

  bool get applyAuthorStyles => true;

  void greet(Event e, var detail, Node target) {
    message = "Hello, " + person.name + "!";
  }
}