import 'defaults.dart'; // Import the new defaults file
import 'models/user.dart';

void main() {
  print('--- Testing getInstance() ---');

  // Call the global function generated in `defaults.g.dart`
  final userFromInstance = getInstance<User>();
  print('Fetched User via getInstance(): $userFromInstance');

  // Creating another proves it's a factory
  final anotherUser = getInstance<User>();
  print('Is second user the same instance? ${identical(userFromInstance, anotherUser)}');
}
