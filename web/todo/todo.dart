import 'dart:html';
import 'package:polymer/polymer.dart';

class Item extends Object with ObservableMixin {
  @observable String text;
  @observable bool done;

  Item([String this.text = '', bool this.done = false]) {
    //This doesn't work.
//    text.isEmpty.changes.listen((records) {
//      notifyProperty(this, const Symbol('isEmpty'));
//    });
  }

  // this is currently not updating when text is entered but i'm
  // not yet sure how to do that yet.
  bool get isEmpty => text.isEmpty;

  clone() => new Item(text, done);

  clear() {
    text = '';
    done = false;
  }
}

@CustomTag('todo-element')
class TodoElement extends PolymerElement with ObservableMixin {
  ObservableList<Item> items;
  @observable Item newItem = new Item();

  TodoElement() {
    items = toObservable([
      new Item('Write Polymer in Dart', true),
      new Item('Write Dart in Polymer'),
      new Item('Do something useful')
    ]);

    // Need to check if the items list gets added to or has something removed.
    items.changes.listen((records) {
      notifyProperty(this, const Symbol('remaining'));
    });

    // Also need to check if any of the items in items has a property that changes.
    for (var item in items) {
      item.changes.listen((records) {
        notifyProperty(this, const Symbol('remaining'));
      });
    }
  }

  bool get applyAuthorStyles => true;

  int get remaining {
    int remaining = 0;
    //
    items.forEach((item) {
      if (!item.done) remaining++;
    });
    return remaining;
  }

  void add() {
    if (newItem.text.isEmpty) return;

    items.add(newItem.clone());
    newItem.clear();
  }

  void markAllDone(Event e, var detail, Node target) {
    items.forEach((item) => item.done = true);
  }

  void archiveDone(Event e, var detail, Node target) {
    items.removeWhere((item) => item.done);
  }

  // I don't see this being applied.
  classFor(Item item) {
    item.done ? 'done' : '';
  }

}