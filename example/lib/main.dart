import 'models/user.dart';

void main() {
  // UPDATED: Call the cleaner `User.default()` method.
  final defaultUser = User.default();

  print('Generated Default User:');
  print(defaultUser);
}