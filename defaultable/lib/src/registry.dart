import 'package:meta/meta.dart';

/// An annotation that triggers the generation of the global
/// `getInstance()` function. Place this in one file in your project.
@immutable
class DefaultableRegistry {
  const DefaultableRegistry();
}

/// A constant instance of [DefaultableRegistry] for use as an annotation.
const defaultableRegistry = DefaultableRegistry();
