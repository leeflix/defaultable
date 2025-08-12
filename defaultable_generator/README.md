Here's a `README.md` for your `defaultable\_generator` package, formatted to match the style and content of the one you provided for `defaultable`.



-----



\# Defaultable Generator



\[](https://www.google.com/search?q=%5Bhttps://www.google.com/search%3Fq%3Dhttps://pub.dev/packages/defaultable\_generator%5D\\(https://www.google.com/search%3Fq%3Dhttps://pub.dev/packages/defaultable\_generator\\))

\[](https://www.google.com/search?q=%5Bhttps://opensource.org/licenses/MIT%5D\\(https://opensource.org/licenses/MIT\\))



\*\*Defaultable Generator\*\* is the build-time dependency that does the heavy lifting for the `defaultable` package. It contains the code generation logic, responsible for creating the `.fromDefaults()` factory constructors and the global `getInstance()` factory for your data classes.



This package is a \*\*`dev\_dependency`\*\* and is not used in your final application. It is only required during development to generate the Dart code files.



-----



\## ⚙️ Installation



To use `defaultable\_generator`, you need to add it and `build\_runner` to your `dev\_dependencies` in your `pubspec.yaml` file.



```yaml

dev\_dependencies:

&nbsp; build\_runner: ^2.4.0

&nbsp; defaultable\_generator: ^0.1.0 # Or the latest version

```



You must also include the `defaultable` package in your regular dependencies.



```yaml

dependencies:

&nbsp; defaultable: ^0.1.0 # Or the latest version

```



-----



\## 🚀 Usage



This package is designed to be used via the `dart run build\_runner build` command. You do not need to interact with its classes or functions directly.



The generator looks for two key annotations provided by the `defaultable` package:



1\.  \*\*`@Defaultable()`\*\*: This annotation on a class triggers the generator to create the `\_$classNameFromDefaults()` function and the `\*.defaultable.g.dart` part file.



2\.  \*\*`@defaultableRegistry`\*\*: This annotation on a top-level element (like a class or a constant) triggers the generator to create a global `getInstance()` factory in the corresponding part file.



After setting up your classes with these annotations, you simply run the following command in your terminal from the root of your project:



```bash

dart run build\_runner build --delete-conflicting-outputs

```



The generator will automatically scan your project, find the annotated classes, and produce the necessary `.g.dart` files.



-----



\## 🚧 Configuration



While `defaultable\_generator` works out-of-the-box for most use cases, you can configure its behavior via a `build.yaml` file in the root of your project.



For example, you can adjust the output path or other options. Refer to the `build\_runner` documentation for more details on advanced configuration.



-----



\## 🐛 Issues and Contributions



Please file any issues, bugs, or feature requests on the \[GitHub issue tracker](https://github.com/leeflix/defaultable/issues).

