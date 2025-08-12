import 'package:defaultable/defaultable.dart';

// Import all models you want to be available in getInstance()
import 'models/user.dart';
import 'models/address.dart';
import 'models/phone.dart';
// Note: We don't import Team because it doesn't use @Defaultable

part 'defaults.g.dart';

// This annotation triggers the InstanceGenerator
@defaultableRegistry
class _ {} // The annotation can be on any top-level element
