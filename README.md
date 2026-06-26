# Flutter Shopping Cart

A single-file Flutter app that lets you browse a small product catalogue, add items to a cart, and check out using a Dismissible widget.

---

## Project structure

```
lib/
└── main.dart          
test/
└── widget_test.dart  
pubspec.yaml
README.md
```

---

## Prerequisites

| Tool | Minimum version |
|------|----------------|
| Flutter SDK | 3.19 |
| Dart | 3.3 |
| Android Studio

Install Flutter by following the [official guide](https://docs.flutter.dev/get-started/install). Run `flutter doctor` afterwards and resolve any issues it flags before continuing.

---

## Running the app

```bash
# 1. Clone the project
git clone https://github.com/Faithirakoze/flutter_widgets.git
cd dismissible_widget

# 2. Add dependencies
flutter pub get

# 3. Launch app
flutter run                     
```

---

## The `Dismissible` widget

`Dismissible` is a built-in Flutter widget that lets the user swipe a list item off the screen and automatically removes it from the tree.

### 1. The `key` attribute 

```dart
Dismissible(
  key: Key('$name-$i'),
  ...
)
```

Every `Dismissible` must have a unique `key`. Flutter uses it to track which physical widget corresponds to which item in the list as the list mutates. Using only the product name (`Key(name)`) would break if the same product appeared twice in the cart — both rows would share a key and Flutter would throw an error or remove the wrong one. Combining name and index (`'$name-$i'`) guarantees each row has a distinct identity regardless of duplicates.

### 2. The `direction` and `onDismissed` attributes — controlling the gesture and the side-effect

```dart
Dismissible(
  key: Key('$name-$i'),
  direction: DismissDirection.endToStart,
  onDismissed: (_) => CartService.instance.remove(i),
  ...
)
```

`direction: DismissDirection.endToStart` restricts the swipe to right-to-left only, which matches the conventional "swipe to delete" pattern on both Android and iOS and avoids accidental dismissal when scrolling. `onDismissed` is the callback Flutter uses after the widget has finished its exit animation and has been removed from the tree. Calling `CartService.instance.remove(i)` here keeps the data layer in sync with what the user already sees, the row is gone visually before the list rebuilds, so there is no flicker or double-remove.

### 3. The `background` attribute 

```dart
Dismissible(
  key: Key('$name-$i'),
  direction: DismissDirection.endToStart,
  onDismissed: (_) => CartService.instance.remove(i),
  background: Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    decoration: BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.delete_outline, color: Colors.white, size: 22),
        SizedBox(height: 4),
        Text('Remove', style: TextStyle(color: Colors.white, fontSize: 11)),
      ],
    ),
  ),
  child: ..., // the visible cart row
)
```

`background` is the widget that sits *behind* the foreground child and is revealed as the user drags. Because `direction` is end-to-start, only one background slot is needed (if both directions were enabled, a `secondaryBackground` would cover the right-to-left swipe). The content of a red `Container` with a trash icon and a "Remove" label is aligned to the right edge so it appears exactly where the user's finger is pulling toward. This is pure layout; no animation code is written manually because `Dismissible` handles the slide and fade internally.

---

## AI Usage

AI was used during development to review code and help debug errors.
