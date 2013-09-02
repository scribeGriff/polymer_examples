import 'dart:html';
import 'package:polymer/polymer.dart';

/// The Item class represents an item in the Todo list.
class Item extends Object with ObservableMixin {
  @observable String text;
  @observable bool done;

  Item([String this.text = '', bool this.done = false]) {
    // Monitor the done boolean to add/remove done class.
    bindProperty(this, const Symbol('done'),
        () => notifyProperty(this, const Symbol('doneClass')));
  }

  // Check if item text is empty.
  bool get isEmpty => text.isEmpty;

  // Copy the item.
  Item clone() => new Item(text, done);

  // Clear the items.
  void clear() {
    text = '';
    done = false;
  }

  // Apply a done class for completed items.
  String get doneClass {
    if (done) return 'done';
    else return '';
  }
}

/// The todo-element.
@CustomTag('todo-element')
class TodoElement extends PolymerElement with ObservableMixin {
  ObservableList<Item> items;
  @observable Item newItem = new Item();
  ButtonElement addButton;
  ButtonElement clearButton;

  TodoElement() {
    // Start off with a few items.
    items = toObservable([
      new Item('Learn about Dart', true),
      new Item('Learn about Polymer'),
      new Item('Create first Polymer app')
    ]);

    // Need to check if the items list gets added to or has something removed.
    items.changes.listen((records) {
      notifyProperty(this, const Symbol('remaining'));
    });

    // Also need to check if any of the items in items has a property that
    // changes.
    for (var item in items) {
      item.changes.listen((records) {
        notifyProperty(this, const Symbol('remaining'));
      });
    }

    // Check if text has been entered to enable buttons.
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

  // Query the add and clear buttons.
  void created() {
    super.created();
    addButton = shadowRoot.query("#add");
    clearButton = shadowRoot.query("#clear");
    addButton.disabled = true;
    clearButton.disabled = true;
  }

  // Apply the styles.
  bool get applyAuthorStyles => true;

  // Calculate remaining todo items.
  int get remaining {
    int remaining = 0;
    items.forEach((item) {
      if (!item.done) remaining++;
    });
    return remaining;
  }

  // Add a new item.
  void add(Event e, var detail, Node target) {
    if (newItem.text.isEmpty) return;
    var item = newItem.clone();
    items.add(item);
    newItem.clear();
    item.changes.listen((records) {
      notifyProperty(this, const Symbol('remaining'));
    });
  }

  // Clear the item before adding it.
  void clear(Event e, var detail, Node target) {
    newItem.clear();
  }

  // Mark all items as done.
  void markAllDone(Event e, var detail, Node target) {
    items.forEach((item) => item.done = true);
  }

  // Archive completed items.
  void archiveDone(Event e, var detail, Node target) {
    items.removeWhere((item) => item.done);
  }
}