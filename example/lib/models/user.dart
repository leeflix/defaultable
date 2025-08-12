import 'package:defaultable/defaultable.dart';

part 'user.defaultable.g.dart';

// UPDATED: Use `@Defaultable()` as the annotation. Note the parentheses.
@Defaultable()
// UPDATED: Use `implements Defaultable` instead of `with Magic`.
class User implements Defaultable {
  final String id;
  final int level;
  final DateTime lastLogin;

  User({
    required this.id,
    required this.level,
    required this.lastLogin,
  });

  @override
  String toString() {
    return 'User(id: $id, level: $level, lastLogin: $lastLogin)';
  }
}