import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:defaultable/defaultable.dart';
import 'package:recase/recase.dart';
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

    final className = element.name!;
    final functionName = '_\$${ReCase(className).camelCase}FromDefaults';
    final constructor = _findViableConstructor(element);
    final buffer = StringBuffer();

    buffer.writeln('$className $functionName() {');
    buffer.writeln('  return $className(');

    for (final param in constructor.formalParameters) {
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

  // ... _findViableConstructor method is unchanged ...
  ConstructorElement _findViableConstructor(ClassElement classElement) {
    return classElement.constructors.firstWhere(
      (c) => !c.isFactory && c.isPublic,
      orElse: () => throw InvalidGenerationSourceError(
        'No public, non-factory constructor found for `${classElement.name}`.',
        element: classElement,
      ),
    );
  }

  String _getDefaultValueForParameter(FormalParameterElement param) {
    final type = param.type;
    final typeElement = type.element;

    // Core types
    if (type.isDartCoreString && type.nullabilitySuffix.toString() == '?') return 'null';
    if (type.isDartCoreString) return "'42'";
    if (type.isDartCoreInt) return '99';
    if (type.isDartCoreDouble) return '42.0';
    if (type.isDartCoreBool) return 'true';
    if (type.isDartCoreList) return 'const []';
    if (type.isDartCoreSet) return 'const {}';
    if (type.isDartCoreMap) return 'const {}';

    // This is the updated, more robust way to check for DateTime
    if (type.element?.library?.isDartCore == false && type.element?.name == 'DateTime') {
      return "DateTime.utc(1970, 1, 1)";
    }

    if (type.nullabilitySuffix.toString() == '?') return 'null';

    // Enum logic
    if (typeElement is EnumElement) {
      final firstValue = typeElement.fields.firstWhere((f) => f.isEnumConstant);
      return '${typeElement.name}.${firstValue.name}';
    }

    // Logic for other defaultable classes
    if (typeElement is ClassElement) {
      if (TypeChecker.typeNamed(Defaultable).isAssignableFrom(typeElement)) {
        return '${typeElement.name}.fromDefaults()';
      }
    }

    throw InvalidGenerationSourceError(
      'Cannot create a default value for parameter `${param.name}` '
      'of type `${type.getDisplayString(withNullability: true)}`. The type is not a core type and does not '
      'implement `Defaultable`.',
      element: param,
    );
  }
}
