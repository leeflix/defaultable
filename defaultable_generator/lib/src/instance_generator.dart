import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:defaultable/defaultable.dart';
import 'package:source_gen/source_gen.dart';

class InstanceGenerator extends GeneratorForAnnotation<DefaultableRegistry> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final reachableLibs = <LibraryElement>{};
    _findReachableLibraries(element.library!, reachableLibs);

    final defaultableClasses = <String>{};
    for (final lib in reachableLibs) {
      for (final classElement in lib.units.expand((u) => u.classes)) {
        if (TypeChecker.fromRuntime(Defaultable)
            .hasAnnotationOf(classElement)) {
          defaultableClasses.add(classElement.name);
        }
      }
    }

    if (defaultableClasses.isEmpty) {
      return '// No @Defaultable classes found in project.';
    }

    final buffer = StringBuffer();
    buffer.writeln('// ignore_for_file: type_literal_in_constant_pattern');
    buffer.writeln();
    buffer.writeln('T getInstance<T extends Defaultable>() {');
    buffer.writeln('  final instanceFactory = _instanceFactories[T];');
    buffer.writeln('  if (instanceFactory == null) {');
    buffer.writeln(
        '    throw Exception("No default instance factory found for type \$T");');
    buffer.writeln('  }');
    buffer.writeln('  return instanceFactory() as T;');
    buffer.writeln('}');
    buffer.writeln();
    buffer.writeln('final _instanceFactories = <Type, Function>{');
    for (final className in defaultableClasses) {
      buffer.writeln('  $className: $className.fromDefaults,');
    }
    buffer.writeln('};');

    return buffer.toString();
  }

  void _findReachableLibraries(
      LibraryElement library, Set<LibraryElement> reachable) {
    if (!reachable.add(library)) return;
    for (final imported in library.importedLibraries) {
      _findReachableLibraries(imported, reachable);
    }
    for (final exported in library.exportedLibraries) {
      _findReachableLibraries(exported, reachable);
    }
  }
}
