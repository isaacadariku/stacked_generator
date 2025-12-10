import 'package:analyzer/dart/element/element.dart';
import 'package:stacked_generator/src/generators/forms/field_config.dart';
import 'package:test/test.dart';

import '../helpers/element2_mock_helper.dart';

void main() {
  group('ExecutableElementDataExtension -', () {
    group('validatorName -', () {
      test('should return only method name when enclosingElementName is null',
          () {
        final mockElement = createMockExecutableElement2(
          methodName: 'validateEmail',
          enclosingElementName: null,
        );

        final result = mockElement.validatorName;

        expect(result, equals('validateEmail'));
        expect(result, isNot(contains('.')));
      });

      test(
          'should return only method name when enclosingElementName is empty string',
          () {
        final mockElement = createMockExecutableElement2(
          methodName: 'validateAccountNumber',
          enclosingElementName: '',
        );

        final result = mockElement.validatorName;

        expect(result, equals('validateAccountNumber'));
        // This is the critical test - should NOT generate dot-shorthand syntax like '.validateAccountNumber'
        expect(result, isNot(startsWith('.')),
            reason: 'Should not generate dot-shorthand syntax');
      });

      test(
          'should return ClassName.methodName when enclosingElementName is valid',
          () {
        final mockElement = createMockExecutableElement2(
          methodName: 'validateEmail',
          enclosingElementName: 'Validators',
        );

        final result = mockElement.validatorName;

        expect(result, equals('Validators.validateEmail'));
        expect(result, contains('.'));
      });

      test('should handle null executable element', () {
        const ExecutableElement? mockElement = null;

        final result = mockElement.validatorName;

        expect(result, isNull);
      });

      test('should correctly identify when enclosing element name exists', () {
        final mockElementWithEnclosing = createMockExecutableElement2(
          methodName: 'validate',
          enclosingElementName: 'Helper',
        );
        final mockElementWithoutEnclosing = createMockExecutableElement2(
          methodName: 'validate',
          enclosingElementName: null,
        );

        expect(mockElementWithEnclosing.hasEnclosingElementName, isTrue);
        expect(mockElementWithoutEnclosing.hasEnclosingElementName, isFalse);
      });
    });

    group('validatorPath -', () {
      test('should return the library source URI', () {
        final mockElement = createMockExecutableElement2(
          methodName: 'validate',
          sourceUri: 'package:my_app/validators.dart',
        );

        final result = mockElement.validatorPath;

        expect(result, equals('package:my_app/validators.dart'));
      });

      test('should handle null executable element', () {
        const ExecutableElement? mockElement = null;

        final result = mockElement.validatorPath;

        expect(result, isNull);
      });
    });
  });
}
