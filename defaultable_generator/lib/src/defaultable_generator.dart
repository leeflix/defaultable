import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:defaultable/defaultable.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

class DefaultableGenerator extends GeneratorForAnnotation<Defaultable> {
  @override
  String generateForAnnotatedElement(
      Element2 element,
      ConstantReader annotation,
      BuildStep buildStep,
      ) {
    if (element is! ClassElement2) {
      throw InvalidGenerationSourceError(
        '`@Defaultable()` can only be used on classes.',
        element: element,
      );
    }

    final constructor = _findViableConstructor(element);
    final buffer = StringBuffer();

    final className = element.name3!;
    final genericParamsWithBounds = _genericParametersAsString(element, withBounds: true);
    final genericParamsWithoutBounds = _genericParametersAsString(element, withBounds: false);
    final functionName = '_\$${ReCase(className).camelCase}FromDefaults';

    // Return type: className<T> without bounds
    // Function generic parameters: <T extends Model<T>> with bounds
    buffer.writeln('$className$genericParamsWithoutBounds $functionName$genericParamsWithBounds() {');
    buffer.writeln('  return $className$genericParamsWithoutBounds(');

    for (final param in constructor.formalParameters) {
      final value = _getDefaultValueForParameter(param);
      if (param.isNamed) {
        buffer.write('    ${param.name3}: $value,');
      } else {
        buffer.write('    $value,');
      }
      buffer.writeln();
    }

    buffer.writeln('  );');
    buffer.writeln('}');

    return buffer.toString();
  }

  ConstructorElement2 _findViableConstructor(ClassElement2 classElement) {
    return classElement.constructors2.firstWhere(
          (c) => c.isPublic,
      orElse: () => throw InvalidGenerationSourceError(
        'No public, non-factory constructor found for `${classElement.name3}`.',
        element: classElement,
      ),
    );
  }

  String _getDefaultValueForParameter(FormalParameterElement param) {
    final type = param.type;
    final typeElement = type.element3;

    // Core types
    if (type.isDartCoreString && type.nullabilitySuffix.toString() == '?') return 'null';
    if (type.isDartCoreString) return "'42'";
    if (type.isDartCoreInt) return '99';
    if (type.isDartCoreDouble) return '42.0';
    if (type.isDartCoreBool) return 'true';
    if (type.isDartCoreList) return 'const []';
    if (type.isDartCoreSet) return 'const {}';
    if (type.isDartCoreMap) return 'const {}';

    // DateTime check
    if (type.element?.library?.isDartCore == false && type.element?.name == 'DateTime') {
      return "DateTime.utc(1970, 1, 1)";
    }

    if (type.nullabilitySuffix.toString() == '?') return 'null';

    // Enum logic
    if (typeElement is EnumElement2) {
      final firstValue = typeElement.fields2.firstWhere((f) => f.isEnumConstant);
      return '${typeElement.name3}.${firstValue.name3}';
    }

    // Other Defaultable classes
    if (typeElement is ClassElement2) {
      // Uncomment if you want to check for @Defaultable annotation
      // if (TypeChecker.fromRuntime(Defaultable).isAssignableFrom(typeElement)) {
      return '${typeElement.name3}.fromDefaults()';
      // }
    }

    throw InvalidGenerationSourceError(
      'Cannot create a default value for parameter `${param.name3}` '
          'of type `${type.getDisplayString(withNullability: true)}`. The type is not a core type and does not '
          'implement `Defaultable`.',
      element: param,
    );
  }

  String _genericParametersAsString(ClassElement2 element, {bool withBounds = true}) {
    if (element.typeParameters2.isEmpty) return '';
    final buffer = StringBuffer('<');
    for (var i = 0; i < element.typeParameters2.length; i++) {
      final param = element.typeParameters2[i];
      buffer.write(param.name3);
      if (withBounds && param.bound != null) {
        buffer.write(' extends ${param.bound!.getDisplayString(withNullability: false)}');
      }
      if (i < element.typeParameters2.length - 1) buffer.write(', ');
    }
    buffer.write('>');
    return buffer.toString();
  }
}
