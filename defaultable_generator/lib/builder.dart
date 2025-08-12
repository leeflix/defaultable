import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:defaultable_generator/src/defaultable_generator.dart';

Builder defaultableBuilder(BuilderOptions options) =>
    SharedPartBuilder([DefaultableGenerator()], 'defaultable');