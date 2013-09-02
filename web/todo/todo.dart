import 'dart:html';
import 'package:polymer/polymer.dart';

class Item extends Object with ObservableMixin {
  @observable String text;
  @observable bool done;

  Item([String this.text = '', bool this.done = false]);

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
  ButtonElement addButton;
  ButtonElement clearButton;

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
    // note this only adds the listener for the items in items at instantiation
    // and not when adding afterwards.
    for (var item in items) {
      if (item.done) {
        print('finished with ${item.text}');
      }
      item.changes.listen((records) {
        notifyProperty(this, const Symbol('remaining'));
        if (item.done) {
          print('finished with ${item.text}');
        }
      });
    }

    newItem.changes.listen((records) {
      if(newItem.isEmpty) {
        addButton.disabled = true;
        clearButton.disabled = true;
      } else {
        addButton.disabled = false;
        clearButton.disabled = false;
      }
    });
  }

  void created() {
    super.created();
    addButton = shadowRoot.query("#add");
    clearButton = shadowRoot.query("#clear");
    addButton.disabled = true;
    clearButton.disabled = true;
  }

  bool get applyAuthorStyles => true;

  int get remaining {
    int remaining = 0;
    items.forEach((item) {
      if (!item.done) remaining++;
    });
    return remaining;
  }

  void add(Event e, var detail, Node target) {
    if (newItem.text.isEmpty) return;
    var item = newItem.clone();
    items.add(item);
    newItem.clear();
    item.changes.listen((records) {
      notifyProperty(this, const Symbol('remaining'));
      if (item.done) {
        print('finished with ${item.text}');
      }
    });
  }

  void clear(Event e, var detail, Node target) {
    newItem.clear();
  }

  void markAllDone(Event e, var detail, Node target) {
    items.forEach((item) => item.done = true);
  }

  void archiveDone(Event e, var detail, Node target) {
    items.removeWhere((item) => item.done);
  }

  String classFor(Item item) {
    print('this is getting called');
    if (item.done) return 'done';
    else return '';
  }
}