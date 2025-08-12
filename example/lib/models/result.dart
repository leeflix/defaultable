// NOTE: This class demonstrates the limitation with generic types.
// The generator cannot handle type `T`, so this class cannot use @Defaultable.
// The user of the package would have to write any desired default logic
// themselves, like the static method below.

class Result<T> {
  final T data;

  Result({required this.data});

  // Example of a manually written static method for a specific type.
  static Result<int> intResultFromDefaults() {
    return Result(data: 0);
  }

  @override
  String toString() => 'Result(data: $data)';
}
