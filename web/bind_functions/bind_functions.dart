import 'dart:html';
import 'package:polymer/polymer.dart';

class Person {
  String name;

  Person([this.name = '']);
}

class Greetings extends Object with ObservableMixin {
  @observable String name;
  @observable String message;
  Person user;

  Greetings() {
    print('added person user');
    user = new Person();
  }

  void greet(Event e, var detail, Element target) {
    print('got the message');
    //user.name = target.attributes['data-msg'];
    message = target.attributes['data-msg'];
    //message = "Hello, " + user.name + "!";
  }
}

main() {
  query('#tmpl').model = new Greetings();
}