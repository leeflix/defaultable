# Defaultable Generator

[![Pub Package](https://img.shields.io/pub/v/defaultable_generator.svg)](https://pub.dev/packages/defaultable_generator)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Defaultable Generator** is the build-time dependency that powers the `defaultable` package.
It contains the code generation logic responsible for creating:

* `.fromDefaults()` factory constructors
* The global `getInstance()` factory for your data classes.

This package is a **`dev_dependency`** — it is not used in your final application.
It’s only required during development to generate Dart code.

---

## ⚙️ Installation

Add `defaultable_generator` and `build_runner` to your **dev\_dependencies** in `pubspec.yaml`:

```yaml
dev_dependencies:
  build_runner: ^2.4.0
  defaultable_generator: ^0.1.0 # Or the latest version
```

Also include the `defaultable` package in your regular **dependencies**:

```yaml
dependencies:
  defaultable: ^0.1.0 # Or the latest version
```

---

## 🚀 Usage

You normally interact with this package via the `dart run build_runner build` command —
you do not call its classes or functions directly.

The generator reacts to two annotations from the `defaultable` package:

1. **`@Defaultable()`**
   Placed on a class to generate:

    * `_$ClassNameFromDefaults()` function
    * `*.defaultable.g.dart` part file

2. **`@defaultableRegistry`**
   Placed on a top-level element (like a class or constant) to generate:

    * A global `getInstance()` factory in the corresponding part file

After adding these annotations, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The generator will scan your project, find annotated classes, and produce the `.g.dart` files automatically.

---

## 🚧 Configuration

`defaultable_generator` works out-of-the-box for most projects.
If needed, you can configure its behavior via a `build.yaml` file in your project root.

For example, you might:

* Change output paths
* Adjust generation options

See the [`build_runner` documentation](https://pub.dev/packages/build_runner) for advanced configuration details.

---

## 🐛 Issues and Contributions

Please report bugs, request features, or contribute on the
[GitHub Issue Tracker](https://github.com/leeflix/defaultable/issues).

---

Do you want me to also **add an example section** showing a minimal `@Defaultable()` class and its generated output? That could make the README more approachable.
