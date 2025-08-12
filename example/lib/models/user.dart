import 'package:defaultable/defaultable.dart';
import 'address.dart';
import 'phone.dart';
import 'team.dart';

part 'user.defaultable.g.dart';

@Defaultable()
class User implements Defaultable {
  final String id;
  final int level;
  final Address? address;
  final List<Phone> phones;
  final Team team;

  User({
    required this.id,
    required this.level,
    required this.address,
    required this.phones,
    required this.team,
  });

  factory User.fromDefaults() => _$userFromDefaults();

  @override
  String toString() {
    return 'User(id: $id, level: $level, address: $address, phones: $phones, team: ${team.teamName})';
  }
}
