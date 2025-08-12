import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:defaultable/defaultable.dart'; // This import now points to the new structure
import 'package:source_gen/source_gen.dart';

class DefaultableGenerator extends GeneratorForAnnotation<Defaultable> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@Defaultable()` can only be used on classes.',
        element: element,
      );
    }

    // UPDATED: Check for the `Defaultable` interface instead of `Magic`.
    if (!TypeChecker.fromRuntime(Defaultable).isAssignableFrom(element)) {
      throw InvalidGenerationSourceError(
        'Class `${element.name}` must implement `Defaultable`.',
        element: element,
      );
    }
    
    final className = element.name;
    final constructor = _findViableConstructor(element);
    final buffer = StringBuffer();

    buffer.writeln('extension Default$className on $className {');
    // UPDATED: The method name is now `default()`.
    buffer.writeln('  static $className default() => $className(');

    for (final param in constructor.parameters) {
      final value = _getDefaultValueForParameter(param);
      if (param.isNamed) {
        buffer.write('    ${param.name}: $value,');
      } else {
        buffer.write('    $value,');
      }
      buffer.writeln();
    }

    buffer.writeln('  );');
    buffer.writeln('}');

    return buffer.toString();
  }

  ConstructorElement _findViableConstructor(ClassElement classElement) {
    return classElement.constructors.firstWhere(
      (c) => !c.isFactory && c.isPublic,
      orElse: () => throw InvalidGenerationSourceError(
        'No public, non-factory constructor found for `${classElement.name}`.',
        element: classElement,
      ),
    );
  }

  String _getDefaultValueForParameter(ParameterElement param) {
    final type = param.type;
    final typeName = type.getDisplayString(withNullability: false);

    if (type.isDartCoreString && type.nullabilitySuffix.toString() == '?') return 'null';
    if (type.isDartCoreString) return "'42'";
    if (type.isDartCoreInt) return '42';
    if (type.isDartCoreDouble) return '42.0';
    if (type.isDartCoreBool) return 'true';
    if (type.isDartCoreList) return 'const []';
    if (type.isDartCoreSet) return 'const {}';
    if (type.isDartCoreMap) return 'const {}';
    if (typeName == 'DateTime') return "DateTime.utc(1970, 1, 1)";
    if (type.nullabilitySuffix.toString() == '?') return 'null';

    final typeElement = type.element;
    if (typeElement is ClassElement) {
      // UPDATED: Check for the `Defaultable` interface on nested types.
      if (TypeChecker.fromRuntime(Defaultable).isAssignableFrom(typeElement)) {
        // UPDATED: Call `.default()` on nested types.
        return '$typeName.default()';
      }
    }
    
    throw InvalidGenerationSourceError(
      'Cannot create a default value for parameter `${param.name}` '
      'of type `$typeName`. The type is not a core type and does not '
      'implement `Defaultable`.',
      element: param,
    );
  }
}