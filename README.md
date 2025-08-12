````markdown
# Defaultable

[![pub version](https://img.shields.io/pub/v/defaultable.svg)](https://pub.dev/packages/defaultable)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Tired of writing boilerplate code to create default or fallback instances of your data classes? **Defaultable** is a code generator that creates a static `.default()` method for you, filled with sensible default values.

This repository is a monorepo containing:
* `packages/defaultable`: The core API package with the `@Defaultable` annotation.
* `packages/defaultable_generator`: The code generator that builds the `.default()` methods.
* `example`: A sample application demonstrating usage.

## ✨ Features

* **Zero Boilerplate**: Annotate your class and let the generator do the work.
* **Sensible Defaults**: Automatically populates fields with default values (`42`, `true`, `[]`, `null`, etc.).
* **Nested Objects**: Recursively calls `.default()` on fields that are also `Defaultable`.
* **Customizable**: Easily provide default implementations for third-party types using extensions.
* **Null-Safe**: Correctly handles nullable and non-nullable types.

## ⚙️ Getting Started

### 1. Installation

Add the necessary dependencies to your `pubspec.yaml`.

```yaml
dependencies:
  defaultable: ^0.1.0 # Use the latest version from pub.dev

dev_dependencies:
  build_runner: ^2.4.0
  defaultable_generator: ^0.1.0 # Use the latest version
````

### 2\. Usage

Using `defaultable` is a simple three-step process.

**Step 1: Annotate your class**

Your class must `implement Defaultable` and be annotated with `@Defaultable()`. Don't forget the `part` directive.

`lib/model/user.dart`

```dart
import 'package:defaultable/defaultable.dart';

part 'user.defaultable.g.dart';

@Defaultable()
class User implements Defaultable {
  final String id;
  final String? email;
  final int level;
  final bool isVerified;
  final List<String> permissions;

  User({
    required this.id,
    this.email,
    required this.level,
    required this.isVerified,
    required this.permissions,
  });
}
```

**Step 2: Run the build command**

Use `build_runner` to generate the part file.

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Use the generated method**

You can now access the static `.default()` method directly on your class.

```dart
import 'model/user.dart';

void main() {
  final defaultUser = User.default();

  print(defaultUser.id);          // '42'
  print(defaultUser.email);       // null
  print(defaultUser.level);       // 42
  print(defaultUser.isVerified);  // true
  print(defaultUser.permissions); // []
}
```

## 🧩 Handling External Types

What about types from other packages that you can't annotate, like `Uuid` or `Decimal`? Easy\! Just create an `extension` on that type with your own static `default()` method. The generator will automatically find and use it.

`lib/utils/default_extensions.dart`

```dart
import 'package:uuid/uuid.dart';

// The user creates this extension for a third-party type.
extension DefaultUuidValue on UuidValue {
  // The generator will find this method!
  static UuidValue default() => UuidValue.fromBytes(List.filled(16, 0));
}
```

## 🐛 Issues and Contributions

Please file any issues, bugs, or feature requests on the [GitHub issue tracker](https://www.google.com/search?q=https://github.com/your_username/defaultable/issues).

Contributions are welcome\! Fork the repository and submit a pull request.

```
**Remember to replace `your_username` in the issue tracker link with your actual GitHub username.**
```