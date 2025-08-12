import 'package:meta/meta.dart';

/// A class that serves as both an annotation and an interface
/// to mark classes for default instance generation.
///
/// Use as an annotation `@Defaultable()` on your class,
/// and then implement it: `class MyClass implements Defaultable`.
@immutable
abstract class Defaultable {
  /// The const constructor allows this class to be used as an annotation.
  const Defaultable();
}