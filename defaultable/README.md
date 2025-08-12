# Defaultable

[](https://www.google.com/search?q=https://pub.dev/packages/defaultable)
[](https://opensource.org/licenses/MIT)

Tired of writing boilerplate code to create default or fallback instances of your data classes? **Defaultable** is a code generation package that creates `.fromDefaults()` factory constructors and an optional global `getInstance()` factory for your data classes.

It's designed to be simple for basic cases and powerful enough to handle complex object graphs.

-----

## ✨ Features

  * **Zero Boilerplate**: Auto-generates `.fromDefaults()` factory constructors for your classes.
  * **Global Factory (Optional)**: Can generate a global `getInstance<T>()` function for easy access to default instances.
  * **Handles Complexity**: Correctly generates values for core types, enums, nested `Defaultable` objects, and lists.
  * **Transparent Limitations**: Provides clear patterns for handling advanced scenarios like cyclic dependencies.

-----

## ⚙️ Installation

Add the necessary dependencies to your `pubspec.yaml`.

```yaml
dependencies:
  defaultable: ^0.1.0 # Or the latest version from pub.dev

dev_dependencies:
  build_runner: ^2.4.0
  defaultable_generator: ^0.1.0 # Or the latest version
```

-----

## 🚀 Usage: Generating `.fromDefaults()` (Core Feature)

This is the main feature of the package. To make a class `Defaultable`, you need to do three things.

#### **1. Set up your class**

You must add the **`@Defaultable()`** annotation, **`implements Defaultable`**, the **`part`** directive, and a **`factory`** constructor that delegates to the generated function.

**`lib/models/address.dart`**

```dart
import 'package:defaultable/defaultable.dart';

part 'address.defaultable.g.dart';

@Defaultable()
class Address implements Defaultable {
  final String street;
  final String city;

  Address({required this.street, required this.city});

  // Add this factory to call the generated code
  factory Address.fromDefaults() => _$addressFromDefaults();

  @override
  String toString() => 'Address(street: $street, city: $city)';
}
```

#### **2. Run the build command**

Use `build_runner` to generate the `*.defaultable.g.dart` file.

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### **3. Use the generated method**

You can now call the `.fromDefaults()` factory directly on your class.

```dart
final defaultAddress = Address.fromDefaults();
print(defaultAddress); // Address(street: 42, city: 42)
```

-----

## ⚡ Advanced Usage: The Global `getInstance()` Factory

You can also generate a single, global `getInstance<T>()` function that acts as a factory for all your `Defaultable` types.

#### **1. Create a "Registry" File**

Create one file in your project (e.g., `lib/defaults.dart`). In this file:

1.  Import all the models you want to be available through `getInstance()`.
2.  Add the `@defaultableRegistry` annotation to any top-level element.
3.  Add the corresponding `part` directive.

**`lib/defaults.dart`**

```dart
import 'package:defaultable/defaultable.dart';

// 1. Import all the models you want to register.
import 'models/user.dart';
import 'models/address.dart';
import 'models/phone.dart';

// 3. Add the part directive.
part 'defaults.g.dart';

// 2. This annotation triggers the generator.
@defaultableRegistry
class _ {}
```

#### **2. Run the build command**

The same build command will now also generate `defaults.g.dart`.

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### **3. Use the `getInstance()` function**

Now you can import your registry file and use the global function.

```dart
import 'package:defaultable_example/defaults.dart';
import 'package:defaultable_example/models/address.dart';

void main() {
  final address = getInstance<Address>();
  print(address); // Address(street: 42, city: 42)
}
```

-----

## 🚧 Handling Limitations

Code generation has limits. Here’s how to handle them with `defaultable`.

### Cyclic Dependencies

If `User` contains a `Team` and `Team` contains a `List<User>`, calling `fromDefaults()` on either will cause an infinite loop (`StackOverflowError`).

**The Workaround:** You must break the cycle by manually implementing one of the factories. Remove the `@Defaultable` annotation and `part` directive from that class and write the factory yourself.

```dart
// In team.dart
class Team implements Defaultable {
  final String teamName;
  final List<User> members;

  Team({required this.teamName, required this.members});

  // Manually implemented factory breaks the loop
  factory Team.fromDefaults() {
    return Team(
      teamName: 'Default Team',
      members: [], // The cycle is broken here
    );
  }
}
```

### Generic Types

The generator cannot create defaults for generic classes like `class Result<T> {}`, because it doesn't know what `T` will be.

**The Workaround:** These classes cannot be annotated with `@Defaultable`. You must handle them manually by writing your own static methods or factories.

-----

## 🐛 Issues and Contributions

Please file any issues, bugs, or feature requests on the [GitHub issue tracker](https://github.com/leeflix/defaultable/issues).