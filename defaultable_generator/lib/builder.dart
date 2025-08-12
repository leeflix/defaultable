import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:defaultable_generator/src/defaultable_generator.dart';
import 'package:defaultable_generator/src/instance_generator.dart';

// Builder for the `.defaultable.g.dart` part files
Builder defaultableBuilder(BuilderOptions options) =>
    PartBuilder([DefaultableGenerator()], '.defaultable.g.dart');

// Builder for the `getInstance` registry file
Builder instanceBuilder(BuilderOptions options) =>
    PartBuilder([InstanceGenerator()], '.g.dart');
