import 'package:defaultable/defaultable.dart';
import 'user.dart';

// NOTE: This class demonstrates the workaround for a cyclic dependency.
// It does NOT use @Defaultable. The `fromDefaults` factory is written
// manually to break the infinite loop (by providing `members: []`).

class Team implements Defaultable {
  final String teamName;
  final List<User> members;

  Team({
    required this.teamName,
    required this.members,
  });

  factory Team.fromDefaults() {
    return Team(
      teamName: 'Default Team',
      members: [], // The cycle is broken here!
    );
  }

  @override
  String toString() =>
      'Team(teamName: $teamName, memberCount: ${members.length})';
}
